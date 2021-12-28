all: \
		raise-illegal-instruction-c.exe \
		raise-illegal-instruction-cs/bin/Release/net6.0/raise-illegal-instruction-cs.exe \
		raise-illegal-instruction-cs-tests/bin/Release/net6.0/raise-illegal-instruction-cs-tests.dll

tests: raise-illegal-instruction-cs-tests

raise-illegal-instruction.dll: raise-illegal-instruction.c
	gcc -o $@ -shared -std=gnu99 -pedantic -Os -Wall -m64 -Wl,--kill-at $^
	strip $@

raise-illegal-instruction-c.exe: raise-illegal-instruction-c.c raise-illegal-instruction.dll
	gcc -o $@ -std=gnu99 -pedantic -Os -Wall -m64 $^
	strip $@
	ldd $@

raise-illegal-instruction-cs/bin/Release/net6.0/raise-illegal-instruction-cs.exe: raise-illegal-instruction-cs/*.cs raise-illegal-instruction-cs/*.csproj raise-illegal-instruction.dll
	cd raise-illegal-instruction-cs && dotnet build --configuration Release

raise-illegal-instruction-cs-tests/bin/Release/net6.0/raise-illegal-instruction-cs-tests.dll: raise-illegal-instruction-cs-tests/*.cs raise-illegal-instruction-cs-tests/*.csproj raise-illegal-instruction.dll
	cd raise-illegal-instruction-cs-tests && dotnet build --configuration Release

raise-illegal-instruction-cs-tests: raise-illegal-instruction-cs-tests/bin/Release/net6.0/raise-illegal-instruction-cs-tests.dll
	# execute unit tests and gather code coverage statistics.
	# see https://github.com/spekt/junit.testlogger/blob/master/docs/gitlab-recommendation.md
	# see https://github.com/coverlet-coverage/coverlet/blob/master/Documentation/VSTestIntegration.md
	dotnet test \
		--configuration Release \
		--test-adapter-path . \
		--logger 'junit;MethodFormat=Class;FailureBodyFormat=Verbose' \
		--collect 'XPlat Code Coverage' \
		--settings raise-illegal-instruction-cs-tests/coverlet.runsettings \
		raise-illegal-instruction-cs-tests

clean:
	rm -f raise-illegal-instruction.dll raise-illegal-instruction-*.exe
	rm -rf */{bin,obj,TestResults}
