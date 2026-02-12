# Banker's Algorithm - Bash Implementation

## Overview
This project is a Bash implementation of the Banker's Algorithm, a classic deadlock avoidance algorithm used in operating systems. This project simulates how resources are allocated to processes and checks whether the system remaims in a safe state. It also evaluates new resource requests to determine if granting them would risk deadlock.

## What the Program Does
1. Accepts input for:
   - Number of processess and resource types
   - Available resources
   - Maximum resource demand and current allocations per process
2. Calculates the remaining resource needs
3. Determines whether a safe execution sequence exists
4. Tests new resource requests to see if they can be granted safely

## Why I Built This
I built this to deepen my understanding of operating systems concepts. I also wanted to practice implementing a theoretical algorithm in a practical way using Bash, since working in a Linux environment is something I'm continuing to develop.

## What I Learned
How deadlocks can be prevented 
How to translate an OS algorithm into a working program
Managing state using arrays and loops in Bash

## What I'd Improve Next
If I continue building on this, I'd like to:
- Re-run the safety check after granting a resource request to fully validate system state
- Add stronger input validation and error handling
- Refactor parts of the script into functions for better readability
- Allow system states to be loaded from a file instead of a manual input
