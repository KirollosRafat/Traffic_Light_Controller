# Traffic Light Contoller:

# Overview:

The Traffic Light Controller is designed to manage the traffic lights at an intersection with two streets, Street A and Street B. It handles the operation of traffic lights by cycling through different states based on the traffic conditions and timing requirements. The controller uses a finite state machine (FSM) and a counter to ensure that the traffic lights change at appropriate intervals.

# States:

The controller uses a finite state machine with four states:

s0: Green light for Street A, Red light for Street B for 60 seconds.
s1: Yellow light for Street A, Red light for Street B for 10 seconds.
s2: Red light for Street A, Green light for Street B for 50 seconds.
s3: Red light for Street A, Yellow light for Street B for 10 seconds.

# Operation

State Transition and Timing:

The controller transitions between states based on a 28-bit counter and the traffic sensor inputs (sa and sb).

The counter is used to keep track of how long each state has been active, and it resets when a state transition occurs.

State s0:

Condition: The counter counts up to 60 seconds if no vehicle is detected on Street B (sb is low).
Lights: Green for Street A, Red for Street B.
Transition: If a vehicle is detected on Street B (sb is high) or the counter reaches 60 seconds, the state transitions to s1.

State s1:

Condition: The counter counts up to 10 seconds.
Lights: Yellow for Street A, Red for Street B.
Transition: After 10 seconds, the state transitions to s2.
State s2:

Condition: The counter counts up to 50 seconds if no vehicle is detected on Street A (sa is low) or Street B is not empty (sb is high).
Lights: Red for Street A, Green for Street B.
Transition: If a vehicle is detected on Street A (sa is high) or Street B is empty (sb is low), the state transitions to s3.
State s3:

Condition: The counter counts up to 10 seconds.
Lights: Red for Street A, Yellow for Street B.
Transition: After 10 seconds, the state transitions back to s0.
