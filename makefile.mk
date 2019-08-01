SHELL = /bin/bash

#
# Makefile, PPRTestbench
#
# author  Ulrike Griefahn, Franz Bachmann
# date    2014-01-16
#
# Aufruf von make:
# - make test=blatt02
#    Teste alle Einsendungen des Blatts 02
#
# - make test=blatt03 user=sample 
#    Teste alle Einsendungen, deren Verzeichnisname den angegebenen String 
#    enth�lt. 

test =blatt01
user =sample

# Sprache setzen, damit Sonderzeichen im Protokoll richtig angezeigt werden.
LANG = #de_DE.UTF-8

# ============================================================================
# Variablen
# ============================================================================

# -----------------------------------------------------------------------------
# Konfiguration Verzeichnisse
# -----------------------------------------------------------------------------

# Globales Source-Verzeichnis
SRC_GLOBAL_DIR = ./src

# Globales Verzeichnis fuer Resources
RESOURCES = ./resources

# Das zu testende Aufgabenblatt, bspw. blatt02 (=Verzeichnis)
TEST_DIR = blatt01

# Verzeichnis mit den eingesendeten Loesungen (Benutzerverzeichnisse)
LOAD_DIR = ./blatt01/submissions

# Verzeichnisse, in denen sich die zu testenden Loesungen befinden
DIRS = $(notdir $(wildcard blatt01/submissions/Ulrike Griefahn_3047252/*))

# Einsendung, die getestet werden soll (=Benutzerverzeichnis)
USR_DIR = $(user)

# Temporaeres Vezeichnis, in dem der Test einer Einsendung durchgefuehrt wird
BUILD = build
BUILD_DIR = ./blatt01/$(BUILD)

# Verzeichnis, in dem sich das blattspezifische Testmodul befindet
TESTS_DIR = ./blatt01/tests

# -----------------------------------------------------------------------------
# Konfiguration Dateien / Programme
# -----------------------------------------------------------------------------

# Teile des Protokolldateinamens
FILE_PROTOCOL_PREFIX=assignsubmission_file
FILE_PROTOCOL=protokoll_blatt01

# max. Groesse der Protokolldatei 
SIZE = 500KB

# Zwischendatei zum Umbenennen der mina-Funktion
TMP_MAIN = $(BUILD_DIR)/ppr_tb_main_renamed.c

# Anwendung zum Test der vom Benutzer definierten Funktionen
USER_SUBMISSION = ppr_tb_submission

# Name des ausfuehrbaren Programms zum ueberwachen der Testdauer (Terminierung)
CTRL = ppr_tb_wait_and_exit

# Name des Moduls mit externen Prototypen
EXTERN_PROTOTYPES_FILE = ppr_tb_extern_prototypes.c

# Name der Datei, in der die Benutzerangaben enthalten sind (Moodle)
USER_PROPERTIES_FILE = UserId.properties
TESTBENCH_USER_NAME=TestBench.User.Name

# -----------------------------------------------------------------------------
# Konfiguration fuer Aktualisierung der Praktikumsleistungen
# -----------------------------------------------------------------------------
# Teildateiname Praktikumsleistungen
LEISTUNGEN = praktikumsleistungen

# Modul zum Protokollieren der Leistungen
LOGGING = ppr_tb_logging

# -----------------------------------------------------------------------------
# Standard-Konfiguration fuer SPLINT
# -----------------------------------------------------------------------------

SPLINT_OPTIONS = -booltype BOOL -boolfalse FALSE -booltrue TRUE \
                 -boolint +predboolint \
                 -type +noret +usedef +infloops \
                 +casebreak -initallelements -incompletetype 
                 
SPLINT_ADD_OPTIONS =

# -----------------------------------------------------------------------------
# Standard-Konfiguration fuer GCC
# -----------------------------------------------------------------------------

GCC_ADD_OPTIONS = 
GCC_MATH_OPTION = -lm
                        
# -----------------------------------------------------------------------------
# Konfiguration fuer Doxygen
# -----------------------------------------------------------------------------

# Doxygen-Programm
#DOXYGEN_EXE = doxygen.exe
DOXYGEN_EXE = doxygen

# Doxygen-Konfigurationsdatei
DOXYGEN_CONF = ppr_doxygen.cfg

# Doxygen-Kommentare (for Testbench only)
DOXYGEN_COMMENT = ppr_tb_doxygen_comment.txt

# Pfad zum Doxygen-Programm aus Umgebungsvariable PATH lesen
#DOXYGEN = "$$(cygpath -pu "$$PATH" | sed 's/:/\n/gi' \
#            | grep doxygen)/$(DOXYGEN_EXE)"         
DOXYGEN = $(DOXYGEN_EXE)

# ============================================================================
# Regeln
# ============================================================================
            
# -----------------------------------------------------------------------------
run_all: setup_all test_all teardown_all
# -----------------------------------------------------------------------------
test_all :
    # Iteriere solange, wie noch Einsendungen (Benutzerloesungen) existieren,
    # von denen Jede einzeln getestet wird (run_single). Die Auswertungs-
    # ergebnisse werden jeweils in eine Protokolldatei geschrieben. Dabei sorgt
    # split dafuer, dass die vom Benutzerprogramm generierten Ausgaben begrenzt
    # werden (SIZE = max. Protokolldateigroesse)                               
	@for DIR in $(DIRS); do                                                    \
		# Der Benutzerverzeichnisname wird vervollstaendigt, indem             \
		# "<Nachname>_<Moodle-Nr>" an den zuvor ermittelten "<Vorname>"-       \
		# Teil angehaengt wird (es koennen mehrere Vornamen und auch           \
		# mehrere Nachnamen vorkommen!)                                        \
		# Format:<Vorname> <Nachname>_<Moodle-Nr>                              \
		USR_DIR+="$$DIR";                                                      \
			                                                                   \
		if [ -d $(LOAD_DIR)/"$$USR_DIR" ]; then                                \
			# Aktuelles Benutzerverzeichnis ausgeben                           \
			echo Teste...  $$USR_DIR;                                          \
			                                                                   \
			# Pfad zum Benutzerverzeichnis konstruieren                        \
			FULL_USR_DIR="$(LOAD_DIR)/$$USR_DIR";                              \
			                                                                   \
			# Pfad zur Auswertungsprotokolldatei konstruieren                  \
			PROTOCOL="$$FULL_USR_DIR"/$(FILE_PROTOCOL);                        \
			                                                                   \
			# Schreibgeschuetzte Datei (.01) neu anlegen, die dazu dient, beim \
			# Erreichen der max. zulaessigen Groesse des Auswertungsprotokolls \
			# (.00), den split-Prozess und damit den Test der jeweiligen       \
			# Benutzerloesung, abzubrechen.                                    \
			rm -f "$$PROTOCOL".txt.01;                                         \
			> "$$PROTOCOL".txt.01;                                             \
			chmod 444 "$$PROTOCOL".txt.01;                                     \
			                                                                   \
			# Der eigentliche - Blatt-spezifische - Test                       \
			time($(MAKE) run_single USR_DIR="$$USR_DIR"                        \
			             --no-print-directory 2>&1                             \
			    | split -d --bytes=$(SIZE) - "$$PROTOCOL".txt. 2> /dev/null    \
			    ) 2>> "$$PROTOCOL".txt.00;                                     \
			                                                                   \
			# Verzeichnispfade kuerzen und in Protokolldatei schreiben         \
			sed ' s/.*\/$(BUILD)\///gi' "$$PROTOCOL".txt.00 2>&1               \
			 | cat > "$$PROTOCOL".txt;                                         \
			                                                                   \
			# PDF erzeugen (dabei UTF-8 in ISO-8859-1 überführen)              \
			iconv -c -f utf-8 -t ISO-8859-1 -o "$$PROTOCOL".tmp "$$PROTOCOL".txt; \
			mv -f "$$PROTOCOL".tmp "$$PROTOCOL".txt;                           \
			a2ps -R --columns=1 "$$PROTOCOL".txt -o "$$PROTOCOL".ps 2> /dev/null; \
			ps2pdf -sPAPERSIZE=a4 "$$PROTOCOL".ps "$$PROTOCOL".pdf 2> /dev/null;              \
			mv -f "$$PROTOCOL".pdf "$$FULL_USR_DIR"/"$$USR_DIR"_$(FILE_PROTOCOL_PREFIX)_$(FILE_PROTOCOL).pdf \
			                                                                   \
			# nicht mehr benoetigte Dateien loeschen                           \
			rm -f "$$PROTOCOL".txt.*;                                          \
# TODO		rm -f "$$PROTOCOL".txt;                                            \
			rm -f "$$PROTOCOL".ps;                                             \
			                                                                   \
			# Benutzerverzeichnisname zuruecksetzen                            \
			USR_DIR="";                                                        \
		else                                                                   \
			# Benutzerverzeichnisname weiter aufbauen                          \
			USR_DIR+=" ";                                                      \
		fi;                                                                    \
	done

# -----------------------------------------------------------------------------
# Regel fuer das Aufraeumen vor dem Test
setup_all :
    # Praktikumsleistungen-Ausgangsdatei heranziehen
	-@rm $(TEST_DIR)/$(LEISTUNGEN)_$(TEST_DIR).csv;
	@cp -n $(LEISTUNGEN).csv $(TEST_DIR)/$(LEISTUNGEN)_$(TEST_DIR).csv;
	@chmod a+rwx $(TEST_DIR)/$(LEISTUNGEN)_$(TEST_DIR).csv;
    
# -----------------------------------------------------------------------------
# Regel fuer das Aufraeumen nach dem Test
teardown_all :
    # Nicht mehr benoetigte Dateien/Verzeichnisse loeschen
	
    
# ----------------------------------------------------------------------------
run_single : setup_single \
             header list_submission \
             splint doxygen compile test \
             cat_submission teardown_single
	
	@echo -e "\f"
	@echo "+--------------------------------------------------------------+"
	@echo "| Benoetigte Zeit (gesamt)                                     |"
	@echo "+--------------------------------------------------------------+"
	@echo     

# ----------------------------------------------------------------------------
# Regel fuer das Vorbereiten des blattspezifischen Tests
setup_single :
    # Temporaeres Build-Verzeichnis samt Inhalt loeschen und neu anlegen
	@rm -rf $(BUILD_DIR);
	@mkdir -p $(BUILD_DIR);
    
    # Loesung ins Build-Verzeichnis kopieren
	@cp $(LOAD_DIR)/"$$USR_DIR"/*.* $(BUILD_DIR)/
    
    # alte Protokolle und UserId.properties-Datei loeschen
	@rm -f $(BUILD_DIR)/*$(FILE_PROTOCOL).*;
    
# ----------------------------------------------------------------------------
# Regel fuer das Aufraeumen nach dem Test
teardown_single :
	@rm -rf $(BUILD_DIR);

# ----------------------------------------------------------------------------
# Header fuer die Protokolldatei erzeugen
header :
	@echo "+--------------------------------------------------------------+"
	@echo "| $(LABEL)";
	@echo "+--------------------------------------------------------------+" 
	@echo
	@cat $(LOAD_DIR)/"$$USR_DIR"/$(USER_PROPERTIES_FILE) \
	      | grep -w "$(TESTBENCH_USER_NAME)" \
	      | sed 's/$(TESTBENCH_USER_NAME)=//g' 
	@date
    
# ----------------------------------------------------------------------------
# Regel fuer das Auflisten der vom Benutzer eingesendeten Dateien
list_submission :
	@echo
	@echo "+--------------------------------------------------------------+"
	@echo "| Eingesendete Dateien                                         |"
	@echo "+--------------------------------------------------------------+"
	@echo    
	@mkdir -p $(BUILD_DIR);
	@cd $(BUILD_DIR) \
		&& ls --file-type -1 -U \
            | grep -v $(USER_PROPERTIES_FILE) \
            | sed 's/.*\///g' \
            | grep . 2> /dev/null;
	
# ----------------------------------------------------------------------------
# Regel fuer das Auflisten der vom Benutzer eingesendeten Dateien
cat_submission :
	@echo -e "\f"; 
	@echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	@echo -e "\t   ###    ##    ## ##     ##    ###    ##    ##  ######   ";
	@echo -e "\t  ## ##   ###   ## ##     ##   ## ##   ###   ## ##    ##  ";
	@echo -e "\t ##   ##  ####  ## ##     ##  ##   ##  ####  ## ##        ";
	@echo -e "\t##     ## ## ## ## ######### ##     ## ## ## ## ##   #### ";
	@echo -e "\t######### ##  #### ##     ## ######### ##  #### ##    ##  ";
	@echo -e "\t##     ## ##   ### ##     ## ##     ## ##   ### ##    ##  ";
	@echo -e "\t##     ## ##    ## ##     ## ##     ## ##    ##  ######   ";
	@echo    
	@for file in $(LOAD_DIR)/"$$USR_DIR"/*.[ch]; do \
		echo -e "\f"; \
		echo "+-------------------------------------------------------------------------+"; \
		echo "| Listing der Datei:                                                      |"; \
		echo "| $$file"; \
		echo "+-------------------------------------------------------------------------+"; \
		echo; \
		cat -n "$$file"; \
	done
	
# ----------------------------------------------------------------------------
# Regel fuer die statische Code-Pruefung mit Splint
splint : splint-setup
	@echo -e "\f"; 
	@echo "+--------------------------------------------------------------+"
	@echo "| Loesung mit Splint pruefen                                   |"
	@echo "+--------------------------------------------------------------+"
	@echo
    
    # ggf. Modul mit den Prototypen externer Funktionen der Loesung hinzufuegen
	@cp $(TESTS_DIR)/$(EXTERN_PROTOTYPES_FILE) $(BUILD_DIR)/ 2>/dev/null || :;
    
    # Splint-Test
	-@splint $(BUILD_DIR)/*.c -weak $(SPLINT_OPTIONS) $(SPLINT_ADD_OPTIONS);

    # ggf. nicht mehr benoetigtes Modul mit den Prototypen loeschen
	@rm -f $(BUILD_DIR)/$(EXTERN_PROTOTYPES_FILE);

# ----------------------------------------------------------------------------
# Regel fuer das Pruefen der Programmkommentare mit Doxygen
doxygen :
	@echo -e "\f"; 
	@echo "+--------------------------------------------------------------+"
	@echo "| Programmkommentare mit Doxygen pruefen                       |"     
	@echo "| Doxygen "$$($(DOXYGEN) --version)
	@echo "+--------------------------------------------------------------+"
	@echo
    
    # Konfigurationsdatei ins build-Verzeichnis kopieren, da beim Aufruf 
    # keine Pfadangabe moeglich ist (muesste ein Windows-Pfad sein)
	@cp $(RESOURCES)/$(DOXYGEN_CONF) $(BUILD_DIR)/;

    # Kommentar anhaengen um Beruecksichtung der Datei durch Doxygen zu erzwingen
	@for file in $(BUILD_DIR)/*.c; do \
		cat $(RESOURCES)/$(DOXYGEN_COMMENT) >> "$$file"; \
	done
	
    # Dogygen-Aufruf
	-@cd $(BUILD_DIR) \
	&& $(DOXYGEN) $(DOXYGEN_CONF);
	@echo "Doxygen done"
    
    # Nicht mehr benoetigte Dateien loeschen
	@rm -f $(BUILD_DIR)/$(DOXYGEN_CONF);
    
# ----------------------------------------------------------------------------
# Regel fuer die Kompilierung
compile : compile-setup
    # @echo -e "\f"; 
    # @echo "+--------------------------------------------------------------+"
    # @echo "| Kompilieren mit C89-Standard                                 |"
    # @echo "+--------------------------------------------------------------+"
    # @echo
    # -@gcc $(BUILD_DIR)/*.c -o $(BUILD_DIR)/$(USER_SUBMISSION).o \
                # -std=c89 -Wdeclaration-after-statement -Wvla $(GCC_ADD_OPTIONS) $(GCC_MATH_OPTION);
    # @echo "Compilation done"

	@echo -e "\f"; 
	@echo "+--------------------------------------------------------------+"
	@echo "| Kompilieren mit C11-Standard                                 |"
	@echo "+--------------------------------------------------------------+"
	@echo
	@gcc $(BUILD_DIR)/*.c -o $(BUILD_DIR)/$(USER_SUBMISSION).o \
            -std=c11 $(GCC_ADD_OPTIONS) $(GCC_MATH_OPTION);
	@echo "Compilation done"

# -----------------------------------------------------------------------------
# Blatt-spezifische makefile-Datei einbetten
include blatt01/makefile_blatt01.mk
