import os
import sys

print("Hello World!")
print("Welcome to the first script of the CPAC Course")
print("You are using the following Python:")
executable=sys.executable
print(executable)

if "cpac-venv" in executable:
    print("It looks to me everythng is fine")
else:
    print("""
    Sorry, but something does not look right to me. 
    I don't see the string 'cpac-venv' in your executable, 
    so you may not be using the correct virtual environment. 
    I suggest you to check.""")
