## Assistant

An assistant that actually has permissions to execute commands on the host OS.
As long as the standard output does not contain the expected output, the
assistant will continue to give instructions, and review the instructions for
possibly dangerous operations, before giving an output that encapsulates the
instructions to the OS, and receive the stdout and stderr of the actions.

The overall loop:

1.  User gives an instruction, which includes what they want to see happen or
    what they want to know. The orchestrator (the app itself) passes it to the
    AI, along with any relevant information like the OS as the initial prompt.
2.  The AI creates a plan of execution. If the assistant has no immediate
    answers, it should create a formatted output that contains the
    instructions it want to run.
3.  The instructions are reviewed to verify they are safe to run -- either
    manually, or by a separate AI, to verify that the operation does not cause
    any irreparable damage.
4.  The orchestrator runs the command.
5.  The orchestrator captures all stdout and stderr and feed it back to the AI
    in the continued conversation, and checks with the AI to see if it needs
    anything else.
6.  If the AI needs more information, go to step 2. Otherwise, the AI outputs
    the result after performing necessary summaries from the output and
    conversation history, and the orchestrator returns the result to the user.

Notes:

- All the internal commmands and stdout/stderr should be clearly visible
  to the user unless explicitly requested (e.g. via a flag).
- The AI and the orchestrator should have a stable and consistent communication
  protocol so that the orchestrator knows what outputs are requests to run
  things, and which ones are actual results to be given to the user. Note that
  the orchestrator prompts should probably include formatting request to *not
  use markdown codeblocks* for the JSON output.
- Assume the availability of DEEPSEEK_API_KEY and OPENAI_API_KEY env vars.
- The safety check AI query should also be flag-controlled.
