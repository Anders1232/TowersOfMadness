#-------------------------------------------------------------
#Assume-se uma distribuição Linux como sistema operacional padrão
#-------------------------------------------------------------

COMPILER = g++
#comando para remover pastas
RMDIR = rm -rf
#comando para remover arquivos
RM = rm -f
CD = cd
#comando para executar o make
MAKE = make

LIBS = -lSDL2 -lSDL2_image -lSDL2_mixer -lSDL2_ttf -lm -lpthread
LINK_PATH =

#Se o gcc não reconhecer a flag -fdiagnostics-color basta retirar ela
# FLAGS= -std=c++11 -Wall -pedantic -Wextra -fmax-errors=5 -Wno-unused-parameter -fdiagnostics-color -static-libgcc -static-libstdc++ -Werror=init-self
FLAGS= -std=c++11 -Wall -pedantic -Wextra -fmax-errors=5 -Wno-unused-parameter -fdiagnostics-color=auto -Werror=init-self
DFLAGS = -ggdb -O0

GAME_REPO= https://github.com/Anders1232/TowersOfMadnessGame.git
ENGINE_REPO= https://github.com/Anders1232/RattletrapEngine.git

GAME_PATH= TowersOfMadnessGame
ENGINE_PATH= RattletrapEngine

GAME_INC_PATH = $(GAME_PATH)/include
GAME_SRC_PATH = $(GAME_PATH)/src
GAME_BIN_PATH = $(GAME_PATH)/bin
GAME_DEP_PATH = $(GAME_PATH)/dep
ENGINE_INC_PATH = $(ENGINE_PATH)/include
ENGINE_SRC_PATH = $(ENGINE_PATH)/src
ENGINE_BIN_PATH = $(ENGINE_PATH)/bin
ENGINE_DEP_PATH = $(ENGINE_PATH)/dep

#Uma lista de arquivos por extensão:
GAME_CPP_FILES = $(wildcard $(GAME_SRC_PATH)/*.cpp)
GAME_OBJ_FILES= $(addprefix $(GAME_BIN_PATH)/,$(notdir $(GAME_CPP_FILES:.cpp=.o)))

ENGINE_CPP_FILES = $(wildcard $(ENGINE_SRC_PATH)/*.cpp)
ENGINE_OBJ_FILES= $(addprefix $(ENGINE_BIN_PATH)/,$(notdir $(ENGINE_CPP_FILES:.cpp=.o)))

#Nome do executável
EXEC = JOGO

#-------------------------------------------------------------
#Caso o sistema seja windows
#-------------------------------------------------------------
ifeq ($(OS),Windows_NT)
#comando para remover um diretório recursivamente
RMDIR= rd /s /q
#comando para deletar um único arquivo
RM = del
#comando para fazer o make
MAKE = mingw32-make

#path da SDL
SDL_PATHS = C:/SDL2/x86_64-w64-mingw32 C:/Tools/msys64/mingw64
LINK_PATH = $(addprefix -L,$(addsuffix /lib,$(SDL_PATHS)))
FLAGS += -mwindows
DFLAGS += -mconsole
LIBS := -lmingw32 -lSDL2main $(LIBS)

#Nome do executável
EXEC := $(EXEC).exe

else
UNAME_S := $(shell uname -s)

#-------------------------------------------------------------
#Caso o sistema seja Mac
#-------------------------------------------------------------

ifeq ($(UNAME_S), Darwin)

LIBS = -lm -framework SDL2 -framework SDL2_image -framework SDL2_mixer -framework SDL2_ttf

endif
endif

all:
	@$(CD) $(ENGINE_PATH) && $(MAKE) $(DEBUG_OU_RELEASE)
	@$(CD) $(GAME_PATH) && $(MAKE) $(DEBUG_OU_RELEASE)
	$(COMPILER) -o $(EXEC) $(ENGINE_OBJ_FILES) $(GAME_OBJ_FILES) $(LINK_PATH) $(LIBS) $(FLAGS)


clean:
	-@$(CD) $(ENGINE_PATH) && $(MAKE) clean
	-@$(CD) $(GAME_PATH) && $(MAKE) clean
	-$(RM) $(EXEC)

.PHONY: debug clean release again init commit pull doc reset status
#regra pra debug
print-% : ; @echo $* = $($*)

debug: DEBUG_OU_RELEASE = fdebug
debug: FLAGS += $(DFLAGS)
debug: all

release: DEBUG_OU_RELEASE = frelease
release: FLAGS += -O3 -mtune=native
release: all

again: clean
again: all

help:
	@echo.
	@echo Available targets:
	@echo - release:  Builds the release version (default target)
	@echo - debug:    Builds the debug version
	@echo - doc:      Clean and generate Doxygen documentation(not implemented)
	@echo - dclean:   Clean Doxygen documentation(not implemented)
	@echo - profile:  Builds a version to use with gprof (not implemented)
	@echo - coverage: Builds a version to use with gcov (not implemented)
	@echo - help:     Shows this help
	@echo.

init:
	-git clone $(ENGINE_REPO)
	-git clone $(GAME_REPO)
	@echo CUIDADO os repositórios estão na branch master

commit:
	-$(CD) $(ENGINE_PATH) && git commit
	-$(CD) $(GAME_PATH) && git commit

pull:
	-$(CD) $(ENGINE_PATH) && git pull
	-$(CD) $(GAME_PATH) && git pull

doc:
	-$(CD) $(ENGINE_PATH) && doxygen Doxyfile
	-$(CD) $(GAME_PATH) && doxygen Doxyfile

reset:
	-$(RMDIR) $(ENGINE_PATH)
	-$(RMDIR) $(GAME_PATH)
	git clone $(ENGINE_REPO)
	git clone $(GAME_REPO)
	@echo CUIDADO os resitórios estão na branch master

status:
	-$(CD) $(ENGINE_PATH) && git status
	-$(CD) $(GAME_PATH) && git status
