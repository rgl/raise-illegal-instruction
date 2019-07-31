all: \
		raise-illegal-instruction-c.exe \
		raise-illegal-instruction-cs/bin/publish/raise-illegal-instruction-cs.exe \
		raise-illegal-instruction-cs-tests/bin/publish/raise-illegal-instruction-cs-tests.dll

raise-illegal-instruction.dll: raise-illegal-instruction.c
	gcc -o $@ -shared -std=gnu99 -pedantic -Os -Wall -m64 -Wl,--kill-at $^
	strip $@

raise-illegal-instruction-c.exe: raise-illegal-instruction-c.c raise-illegal-instruction.dll
	gcc -o $@ -std=gnu99 -pedantic -Os -Wall -m64 $^
	strip $@
	ldd $@

raise-illegal-instruction-cs/bin/publish/raise-illegal-instruction-cs.exe: raise-illegal-instruction-cs/*.cs raise-illegal-instruction-cs/*.csproj raise-illegal-instruction.dll
	cd raise-illegal-instruction-cs && dotnet publish --configuration Release --output bin/publish
	cp raise-illegal-instruction.dll raise-illegal-instruction-cs/bin/publish

raise-illegal-instruction-cs-tests/bin/publish/raise-illegal-instruction-cs-tests.dll: raise-illegal-instruction-cs-tests/*.cs raise-illegal-instruction-cs-tests/*.csproj raise-illegal-instruction.dll
	cd raise-illegal-instruction-cs-tests && dotnet publish --configuration Release --output bin/publish
	cp raise-illegal-instruction.dll raise-illegal-instruction-cs-tests/bin/publish

raise-illegal-instruction-cs-tests: raise-illegal-instruction-cs-tests/bin/publish/raise-illegal-instruction-cs-tests.dll
	TMP= TEMP= OpenCover.Console.exe \
		-output:opencover-report.xml \
		-register:path64 \
		'-filter:+[*]* -[*-tests*]* -[*.Tests*]* -[*]*.*Config -[xunit.*]*' \
		'-returntargetcode' \
		'-target:xunit.console.exe' \
		"-targetargs:$< -nologo -noshadow -diagnostics -xml xunit-report.xml"

clean:
	rm -f raise-illegal-instruction.dll raise-illegal-instruction-*.exe
	rm -rf raise-illegal-instruction-cs/{bin,obj}
