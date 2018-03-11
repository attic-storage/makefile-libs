# check os for path params
ifeq ($(OS),Windows_NT)
	PATHSEP=;
	FOLDERSEP=\\
	EXTENSION=.exe
else
	PATHSEP=:
	FOLDERSEP=/
	EXTENSION=""
endif
