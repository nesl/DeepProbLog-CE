from json import dumps

import torch

from deepproblog.dataset import DataLoader, QueryDataset
from deepproblog.engines import ApproximateEngine, ExactEngine
from deepproblog.evaluate import get_confusion_matrix
from data import MNIST_train, MNIST_test, complex_pattern
from network import MNIST_Net
from deepproblog.model import Model
from deepproblog.network import Network
from deepproblog.train import train_model

from typing import Callable, List, Iterable, Tuple

method = "exact"
arity = 3

name = "event_{}_{}".format(method, arity)

train_set = complex_pattern(arity, "train", 0)
test_set = complex_pattern(arity, "test", 0)
train_set.save_to_txt()
test_set.save_to_txt()

train_queries = QueryDataset("data/train.txt")
test_queries = QueryDataset("data/test.txt")


network = MNIST_Net(n=4)

pretrain = 0
if pretrain is not None and pretrain > 0:
    network.load_state_dict(torch.load("models/pretrained/all_{}.pth".format(pretrain)))
net = Network(network, "mnist_net", batching=True)
net.optimizer = torch.optim.Adam(network.parameters(), lr=1e-3)

model = Model("models/ce.pl", [net])
if method == "exact":
    model.set_engine(ExactEngine(model), cache=True)
elif method == "geometric_mean":
    model.set_engine(
        ApproximateEngine(model, 1, ApproximateEngine.geometric_mean, exploration=False)
    )

model.add_tensor_source("train", MNIST_train)
model.add_tensor_source("test", MNIST_test)

loader = DataLoader(train_queries, 2, False)
print(loader.dataset[0])
train = train_model(model, loader, 1, log_iter=100, profile=0)
model.save_state("snapshot/" + name + ".pth")
train.logger.comment(dumps(model.get_hyperparameters()))
train.logger.comment(
    "Accuracy {}".format(get_confusion_matrix(model, test_queries, verbose=1).accuracy())
)
train.logger.write_to_file("log/" + name)
