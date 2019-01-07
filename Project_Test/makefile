# All Targets
all: start

# Tool invocations
# Executable "start" depends on the files ProjectTest.o and Tests.o.
start: bin/ProjectTest.o bin/Tests.o
	@echo 'Building target: start'
	@echo 'Invoking: C++ Linker'
	g++ -pthread -o bin/start bin/ProjectTest.o bin/Tests.o
	@echo 'Finished building target: start'
	@echo 'Executing Project Test'
	reset
	ocaml -I ../ Phases_Tests/readerTest.ml
	ocaml -I ../ Phases_Tests/tag-parserTest.ml
	ocaml -I ../ Phases_Tests/semanticTest.ml
	bin/start $(ARGS)
	rm -f bin/*

# Depends on the source and header files
bin/ProjectTest.o: src/ProjectTest.cpp
	g++ -g -Wall -Weffc++ -std=c++11 -c -Iinclude -o bin/ProjectTest.o src/ProjectTest.cpp

# Depends on the source and header files
bin/Tests.o: src/Tests.cpp
	g++ -g -Wall -Weffc++ -std=c++11 -c -Iinclude -o bin/Tests.o src/Tests.cpp

#Clean the build directory
clean:
	rm -f bin/*
