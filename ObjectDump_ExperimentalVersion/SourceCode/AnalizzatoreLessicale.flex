%{

// GNU General Public License Agreement
// Copyright (C) 2015-2016 Daniele Berto daniele.fratello@gmail.com
//
// objectDump is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software Foundation. 
// You must retain a copy of this licence in all copies. 
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.
// ---------------------------------------------------------------------------------

/**
* @file Analizzatore.c
* @brief This file contains the scanner generated by flex from analizzatore_lessicale.flex file.
* @author Daniele Berto
*/

#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "DefineGeneral.h"
#include "ConfObject.h"
#include "ApplicationSetup.h"
#include "AnalizzatoreUtils.h"
#include "OutputModule.h"

///Definiamo YES e NO per rendere il codice piu' leggibile
#define YES 1
#define NO 0

///Occorre definire la funzione yylex in modo tale che accetti un puntatore a un oggetto ConfObject come parametro.
///E' un modo standard di lavorare con flex.
#define YY_DECL int yylex (ConfObject *mioconfig)

///Puntatori di supporto
char * punt;
char * new_line_string;

///Flag per sapere se stampare o no l'output delle funzioni.
int print = NO;
int only_print = NO;

///Riferimenti al singleton OutputModule.
OutputModule *output_module;

/*!
L'analizzatore lessicale e' controllato da tre start-conditions e dalle variabili print e only print.
Esso puo' scannerizzare il file di configurazione per tre scopi:
	1) Fetchare l'attributo OPEN e porlo nel ConfObject ---> start-condition INIT
	2) Fetchare gli altri attributi e porli nel ConfObject ---> start-condition SETUP
	3) Stampare tutti gli attributi SENZA PORLI nel ConfObject ---> start-condition PRINT
Le variabili print e only_print servono per registrare se l'utente dello scanner vuole anche stampare a video gli attributi letti:
	print == YES ---> stampa la stringa fetchata.
	only_print == YES ---> metti il contenuto della stringa in ConfObject.
Le start-conditions e le variabili print e only_print sono modificate dalle funzioni messe a dichiarate nell'header file Analizzatore.h e definite alla
fine di questo file.
/*/

%}

%x INIT
%x SETUP
%x PRINT

%%

<INIT,PRINT>^[Oo][Pp][Ee][Nn][ \t](([Uu][Ss][Bb])|([Pp][Cc][Ii]))[ \t][0-9]{0,1}[ \t]+[0-9]{0,1}[ \t]+(0|0x[0-9a-fA-F]{8})[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			GetOpenInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[Dd][Rr][Ss]4_[Ff][Rr][Ee][Qq][Uu][Ee][Nn][Cc][Yy][ \t]+(0|1|2)[ \t]*$ {
		if (print == YES)
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->DSR4_Frequency=FindIntegerValue(yytext);
	}

<SETUP,PRINT>^[Gg][Nn][Uu][Pp][Ll][Oo][Tt]_[Pp][Aa][Tt][Hh][ \t]+.+[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
		{
			punt=FindPointer(yytext); 
			mioconfig->gnuplot=(char *)malloc(strlen(punt) + 1); 
			strcpy(mioconfig->gnuplot, punt);
		}
	}

<SETUP,PRINT>^[Oo][Uu][Tt][Pp][Uu][Tt]_[Ff][Ii][Ll][Ee]_[Ff][Oo][Rr][Mm][Aa][Tt][ \t]+(([Bb][Ii][Nn][Aa][Rr][Yy])|([Aa][Ss][Cc][Ii][Ii]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->output_file_format=OutputFileFormat(yytext);
	}

<SETUP,PRINT>^[oO][uU][tT][pP][uU][tT]_[fF][iI][lL][eE]_[hH][eE][aA][dD][eE][rR][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			mioconfig->header_yes_no=YesNoAnswer(yytext);
	}

<SETUP,PRINT>^[Rr][eE][cC][oO][rR][dD]_[lL][eE][nN][gG][tT][hH][ \t]+[0-9]{1,5}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		} 
		if(only_print == NO) 
			mioconfig->record_length=FindIntegerValue(yytext);
	}

<SETUP,PRINT>^[Tt][Ee][Ss][Tt]_[pP][aA][tT][tT][eE][rR][nN][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);		
		} 
		if(only_print == NO)
			mioconfig->test_pattern=YesNoAnswer(yytext);
	}

<SETUP,PRINT>^[eE][nN][aA][bB][lL][eE]_[dD][eE][sS]_[mM][oO][dD][eE][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		} 
		if(only_print == NO) 
			mioconfig->desmod=YesNoAnswer(yytext);
	}

<SETUP,PRINT>^[eE][xX][tT][eE][rR][nN][aA][lL]_[tT][rR][iI][gG][gG][eE][rR][ \t]+(([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[oO][nN][lL][yY])|([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[aA][nN][dD]_[tT][rR][gG][oO][uU][tT])|([dD][iI][sS][aA][bB][lL][eE][dD]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->external_trigger_acquisition_mode=GetAcquisitionMode(yytext);
	}

<SETUP,PRINT>^[fF][aA][sS][tT]_[tT][rR][iI][gG][gG][eE][rR][ \t]+(([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[oO][nN][lL][yY])|([dD][iI][sS][aA][bB][lL][eE][dD]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->fast_trigger_acquisition_mode=GetAcquisitionMode(yytext);
	}

<SETUP,PRINT>^[eE][nN][aA][bB][lL][eE][dD]_[fF][aA][sS][tT]_[tT][rR][iI][gG][gG][eE][rR]_[dD][iI][gG][iI][tT][iI][zZ][iI][nN][gG][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->enable_fast_trigger_digitizing = YesNoAnswer(yytext);
	}

<SETUP,PRINT>^[mM][aA][xX]_[nN][uU][mM]_[eE][vV][eE][nN][tT][sS]_[bB][lL][tT][ \t]+[0-9]{1,4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		} 
		if(only_print == NO) 
			mioconfig->max_num_events_BLT=FindIntegerValue(yytext);
	}

<SETUP,PRINT>^[dD][eE][cC][iI][mM][aA][tT][iI][oO][nN]_[fF][aA][cC][tT][oO][rR][ \t]+[0-9]{1,3}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->decimation_factor=FindIntegerValue(yytext);
	}

<SETUP,PRINT>^[pP][oO][sS][tT]_[tT][rR][iI][gG][gG][eE][rR][ \t]+[0-9]{1,3}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->post_trigger=FindIntegerValue(yytext);
	}

<SETUP,PRINT>^[tT][rR][iI][gG][gG][eE][rR]_[eE][dD][gG][eE][ \t]+([rR][iI][sS][iI][nN][gG]|[fF][aA][lL][lL][iI][nN][gG])[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->rising_falling=OutputRisingFalling(yytext); 
	}

<SETUP,PRINT>^[uU][sS][eE]_[iI][nN][tT][eE][rR][rR][uU][pP][tT][ \t]+[0-9]{1,4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->use_interrupt=FindIntegerValue(yytext);
	}

<SETUP,PRINT>^[fF][pP][iI][oO]_[lL][eE][vV][eE][lL][ \t]+(([Tt][Tt][Ll])|([Nn][Ii][Mm]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			mioconfig->nim_ttl=OutputNIMTTL(yytext);
	}

<SETUP,PRINT>^[wW][rR][iI][tT][eE]_[rR][eE][gG][iI][sS][tT][eE][rR][ \t][0-9]{1,4}[ \t][0-9]{1,4}[ \t][0-9]{1,4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			GetWriteRegisterInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[Cc][Hh][ \t]+[0-9]{1,2}[ \t]+[Ee][Nn][Aa][Bb][Ll][Ee]_[iI][nN][pP][uU][tT][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			ChInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[Gg][Rr][ \t]+[0-9]{1,2}[ \t]+[Ee][Nn][Aa][Bb][Ll][Ee]_[iI][nN][pP][uU][tT][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			GroupInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[aA][lL][lL][ \t]+[Ee][Nn][Aa][Bb][Ll][Ee]_[iI][nN][pP][uU][tT][ \t]+(([yY][eE][sS])|([nN][oO]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			AllInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[Cc][Hh][ \t]+[0-9]{1,2}[ \t]+[dD][cC]_[oO][fF][fF][sS][eE][tT][ \t]+0x[0-9a-fA-F]{4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			ChInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[gG][rR][ \t]+[0-9]{1,2}[ \t]+[dD][cC]_[oO][fF][fF][sS][eE][tT][ \t]+0x[0-9a-fA-F]{4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			GroupInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[fF][aA][sS][tT][ \t]+[0-9]{1,2}[ \t]+[dD][cC]_[oO][fF][fF][sS][eE][tT][ \t]+0x[0-9a-fA-F]{4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			FastInformation(yytext, mioconfig); 
	}

<SETUP,PRINT>^[aA][lL][lL][ \t]+[dD][cC]_[oO][fF][fF][sS][eE][tT][ \t]+0x[0-9a-fA-F]{4}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			AllInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[Cc][Hh][ \t]+[0-9]{1,2}[ \t]+[tT][rR][iI][gG][gG][eE][rR]_[tT][hH][rR][eE][sS][hH][oO][lL][dD][ \t]+0x[0-9a-fA-F]{1,8}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			ChInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[gG][rR][ \t]+[0-9]{1,2}[ \t]+[tT][rR][iI][gG][gG][eE][rR]_[tT][hH][rR][eE][sS][hH][oO][lL][dD][ \t]+0x[0-9a-fA-F]{1,8}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			GroupInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[fF][aA][sS][tT][ \t]+[0-9]{1,2}[ \t]+[tT][rR][iI][gG][gG][eE][rR]_[tT][hH][rR][eE][sS][hH][oO][lL][dD][ \t]+0x[0-9a-fA-F]{1,8}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			FastInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[aA][lL][lL][ \t]+[tT][rR][iI][gG][gG][eE][rR]_[tT][hH][rR][eE][sS][hH][oO][lL][dD][ \t]+0x[0-9a-fA-F]{1,8}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			AllInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[Cc][Hh][ \t]+[0-9]{1,2}[ \t]+[cC][hH][aA][nN][nN][eE][lL]_[tT][rR][iI][gG][gG][eE][rR][ \t]+(([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[oO][nN][lL][yY])|([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[aA][nN][dD]_[tT][rR][gG][oO][uU][tT])|([dD][iI][sS][aA][bB][lL][eE][dD]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			ChInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[gG][rR][ \t]+[0-9]{1,2}[ \t]+[gG][rR][oO][uU][pP]_[tT][rR][gG]_[eE][nN][aA][bB][lL][eE]_[mM][aA][sS][kK][ \t]+0x[0-9a-fA-F]{1,8}[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			GroupInformation(yytext, mioconfig);
	}

<SETUP,PRINT>^[cC][hH][aA][nN][nN][eE][lL]_[eE][nN][aA][bB][lL][eE]_[mM][aA][sS][kK][ \t]+(0|0x[0-9a-fA-F]{1,8})[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		} 
		if(only_print == NO) 
			ChannelEnableMask(yytext, mioconfig);
	}

<SETUP,PRINT>^[gG][rR][oO][uU][pP]_[eE][nN][aA][bB][lL][eE]_[mM][aA][sS][kK][ \t]+(0|0x[0-9a-fA-F]{1})[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO) 
			GroupEnableMask(yytext, mioconfig);
	}

<SETUP,PRINT>^[Ss][Ee][Ll][Ff]_[tT][rR][iI][gG][gG][eE][rR]_[eE][nN][aA][bB][lL][eE]_[mM][aA][sS][kK][ \t]+(0|0x[0-9a-fA-F]{1,8})[ \t]+(([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[oO][nN][lL][yY])|([aA][cC][qQ][uU][iI][sS][iI][tT][iI][oO][nN]_[aA][nN][dD]_[tT][rR][gG][oO][uU][tT])|([dD][iI][sS][aA][bB][lL][eE][dD]))[ \t]*$ {
		if (print == YES) 
		{
			output_module->OutputFlex(yytext, yyleng+1);
		}
		if(only_print == NO)
			ChannelTriggerEnableMask(yytext, mioconfig);
	}

<SETUP,PRINT>^[Ww][Rr][Ii][Tt][Ee][ \t]+[Rr][Ee][Gg][Ii][Ss][Tt][Ee][Rr][ \t]+(0x[0-9a-fA-F]{1,16})[ \t]+(0x[0-9a-fA-F]{1,16})[ \t]*$ {
			if (print == YES) 
			{
				output_module->OutputFlex(yytext, yyleng+1);
			}
			if(only_print == NO) 
				WriteRegister(yytext, mioconfig);
        }

<*>\n
<*>.
%%

int yywrap(void)
{
	return 1;
}

///La funzione trova i parametri OPEN nel file di configurazione e li pone nel ConfObject. Non stampa quello che ha trovato.
int AnalizzaInit(ConfObject * mioconfig, const char *file)
{
	BEGIN(INIT);
	print = NO;
	only_print = NO;
	///printf("Load settings: \n");
	yyin=fopen(file,"r");
	if (yyin==NULL) return 1;
	yylex(mioconfig);
	fclose(yyin);
	return 0;
}

///La funzione trova i parametri di setup nel file di configurazione e li pone nel ConfObject. Non stampa quello che ha trovato.
int AnalizzaSetup(ConfObject * mioconfig, const char *file)
{
	BEGIN(SETUP);
	output_module = OutputModule::Instance();
	print = NO;
	only_print = NO;
	//printf("Load settings: \n");
	yyin=fopen(file,"r");
	if (yyin==NULL) return 1;
	yylex(mioconfig);
	fclose(yyin);
	return 0;
}

///La funzione trova i parametri OPEN nel file di configurazione e li pone nel ConfObject. Stampa quello che ha trovato.
int AnalizzaInitPrint(ConfObject * mioconfig, const char *file)
{
	BEGIN(INIT);
	output_module = OutputModule::Instance();
	print = YES;
	only_print = NO;
	//printf("Load settings: \n");
	yyin=fopen(file,"r");
	if (yyin==NULL) return 1;
	yylex(mioconfig);
	fclose(yyin);
	return 0;
}

///La funzione trova i parametri OPEN nel file di configurazione e li pone nel ConfObject. Stampa quello che ha trovato.
int AnalizzaSetupPrint(ConfObject * mioconfig, const char *file)
{
	BEGIN(SETUP);
	output_module = OutputModule::Instance();
	print = YES;
	only_print = NO;
	//printf("Load settings: \n");
	yyin=fopen(file,"r");
	if (yyin==NULL) return 1;
	yylex(mioconfig);
	fclose(yyin);
	return 0;
}

///La funzione cerca i settaggi nel file di configurazione e li stampa a video. E' usata dal comando 'check' del programma.
void AnalizzaPrint (const char *file)
{
	BEGIN(PRINT);
	output_module = OutputModule::Instance();
	ConfObject *mio_config_tmp;
	print = YES;
	only_print = YES;
	yyin=fopen(file,"r");
	if (yyin==NULL) return;
	yylex(mio_config_tmp);
	fclose(yyin);
}
