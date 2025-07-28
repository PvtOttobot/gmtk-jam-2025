#@tool
#extends Label
#
#const NO_GIT_BRANCH : String = "branch_not_found"
#const NO_GIT_COMMIT : String = "commit_message_not_found"
#
#func update_git_info() -> void:
	#var branch = "branch_not_found"
	#var commit = "commit_message_not_found"
	#var branch_output = []
	#var commit_output = []
	#
	#OS.execute( 'git', ['rev-parse', "--abbrev-ref", 'HEAD'], branch_output, true )
	#if len(branch_output) == 1:
		#branch = branch_output[0]
		#
	#OS.execute( 'git', ['rev-parse', "--abbrev-ref", 'HEAD'], commit_output, true )
	#if len(commit_output) == 1:
		#commit = commit_output[0]
		#
	#text = "git-branch:" + branch + " git-commit:" + commit
	#
#
#func _ready() -> void:
	#update_git_info()
