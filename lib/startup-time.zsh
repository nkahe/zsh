# Record the start time in nanoseconds when Zsh starts
zsh_start_time=$(date +%s%N)

# Define a precmd hook to run just before the prompt is displayed
function show-elapsed-time() {
  # Get the current time just before showing the prompt
  zsh_end_time=$(date +%s%N)

  # Calculate the time difference in milliseconds
  # Convert nanoseconds to milliseconds
  elapsed_time=$(( (zsh_end_time - zsh_start_time) / 1000000 ))

  # Display the total time taken for Zsh to initialize
  echo "Startup time: ${elapsed_time} ms\n"

  add-zsh-hook -d precmd show-elapsed-time
}
