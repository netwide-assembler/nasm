limits:
	dq %limit()		; unlimited
	dq %limit(unlimited)
	dq %limit("unlimited")

	dq %limit("passes")
	dq %limit("passes","current")
	dq %limit("passes","reset")
	dq %limit("passes","default")
	dq %limit("passes","maximum")

	dq %limit("params")
	dq %limit("params","current")
	dq %limit("params","reset")
	dq %limit("params","default")
	dq %limit("params","maximum")

%pragma limit params 9999

	dq %limit("params")
	dq %limit("params","current")
	dq %limit("params","reset")
	dq %limit("params","default")
	dq %limit("params","maximum")

%pragma limit params reset

	dq %limit("params")
	dq %limit("params","current")
	dq %limit("params","reset")
	dq %limit("params","default")
	dq %limit("params","maximum")
