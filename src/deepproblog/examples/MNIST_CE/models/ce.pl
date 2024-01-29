nn(mnist_net,[X],Y,[0,1,2,3]) :: digit(X,Y).


initial_0(a0). final_0(a2).

arc_0(a0,A,a1) :- digit(A,Y), Y is 1.

arc_0(a0,A,a0) :- digit(A,Y), Y is 0.
arc_0(a0,A,a0) :- digit(A,Y), Y is 2.
arc_0(a0,A,a0) :- digit(A,Y), Y is 3.
arc_0(a0,A,a0) :- digit(A,Y), Y is 4.


arc_0(a1,A,a2) :- digit(A,Y), Y is 3.

arc_0(a1,A,a1) :- digit(A,Y), Y is 0.
arc_0(a1,A,a1) :- digit(A,Y), Y is 1.
arc_0(a1,A,a1) :- digit(A,Y), Y is 2.
arc_0(a1,A,a1) :- digit(A,Y), Y is 4.

arc_0(a2,A,a0) :- digit(A,Y), Y is 0.
arc_0(a2,A,a0) :- digit(A,Y), Y is 1.
arc_0(a2,A,a0) :- digit(A,Y), Y is 2.
arc_0(a2,A,a0) :- digit(A,Y), Y is 3.
arc_0(a2,A,a0) :- digit(A,Y), Y is 4.


event_0(Seq) :- 
    initial_0(Node), 
    recognize_0(Node,Seq).

recognize_0(Node,[]) :- 
    final_0(Node).
recognize_0(FromNode,String) :-  
    traverse(Label,String,NewString),
    arc_0(FromNode,Label,ToNode), 
    recognize_0(ToNode,NewString).

traverse(First,[First|Rest],Rest).



initial_1(b0).
final_1(b2).

arc_1(b0,A,b1) :- digit(A,Y), Y is 0.

arc_1(b0,A,b0) :- digit(A,Y), Y is 1.
arc_1(b0,A,b0) :- digit(A,Y), Y is 2.
arc_1(b0,A,b0) :- digit(A,Y), Y is 3.
arc_1(b0,A,b0) :- digit(A,Y), Y is 4.


arc_1(b1,A,b2) :- digit(A,Y), Y is 2.

arc_1(b1,A,b1) :- digit(A,Y), Y is 0.
arc_1(b1,A,b1) :- digit(A,Y), Y is 1.
arc_1(b1,A,b1) :- digit(A,Y), Y is 3.
arc_1(b1,A,b1) :- digit(A,Y), Y is 4.


arc_1(b2,A,b0) :- digit(A,Y), Y is 0.
arc_1(b2,A,b0) :- digit(A,Y), Y is 1.
arc_1(b2,A,b0) :- digit(A,Y), Y is 2.
arc_1(b2,A,b0) :- digit(A,Y), Y is 3.
arc_1(b2,A,b0) :- digit(A,Y), Y is 4.


event_1(Seq) :- 
    initial_1(Node), 
    recognize_1(Node,Seq).

recognize_1(Node,[]) :- 
    final_1(Node).
recognize_1(FromNode,String) :-  
    traverse(Label,String,NewString),
    arc_1(FromNode,Label,ToNode), 
    recognize_1(ToNode,NewString).



isEvent(S) :- event_0(S).
isEvent(S) :- event_1(S).

event(S,ID) :- event_0(S), ID is 0.
event(S,ID) :- event_1(S), ID is 1.

event(S,ID) :- not isEvent(S), ID is 2.