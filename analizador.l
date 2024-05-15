%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void agregarATabla(int clase, const char* valor);
int buscarEnIdentificadores(const char* nombre);
void agregarAIdentificadores(int posicion, const char* nombre, int tipo);
void mostrarTablas();
void agregarALiterales(const char* dato);
void agregarError(int linea, const char* mensaje);
void agregarErrorS( int linea, const char* mensaje);
void agregaratomos(const char* dato);
void siguientedos();
char siguiente();
int programa();
void otrafunc();
int func();
int tipof();
int listarg();
int otroarg();
void cuerpo();
int listdecl();
void decl();
void tipo();
int valorini();
int listvar();
void tipoval();
void asig();
void oparit();
void e();
int ep();
void t();
int tp();
void f();
void oprel();
void sent();
int listas();
void explogica();
int explog();
void exprel();
void oplog();
void enq();
void se();
void q();
void r();
void faz();
void ret();
int valret();
void expcad();
int opcad();
void para();
void trocar();
int casos();
void llama();
int listp();
int param();


// Definición de una estructura para los nodos de la lista de identificadores
typedef struct NodoIdentificador {
    int posicion;
    char nombre[100]; // Puedes ajustar el tamaño según tus necesidades
    int tipo;
    struct NodoIdentificador* siguiente;
} NodoIdentificador;


// Definición de una estructura para los nodos de la tabla de símbolos
typedef struct NodoTabla {
   
    char valor[100]; // Puedes ajustar el tamaño según tus necesidades
    int clase;
    struct NodoTabla* siguiente;
} NodoTabla;


typedef struct NodoLiteral {
    int posicion;
    char dato[100]; // Puedes ajustar el tamaño según tus necesidades
    struct NodoLiteral* siguiente;
} NodoLiteral;

typedef struct NodoError {
    int linea;  // Número de línea donde se encontró el error
    char mensaje[100];  // Puedes ajustar el tamaño según tus necesidades
    struct NodoError* siguiente;
} NodoError;

typedef struct NodoErrorS {
    int linea;  // Número de línea donde se encontró el error
    char mensaje[100];  // Puedes ajustar el tamaño según tus necesidades
    struct NodoErrorS* siguiente;
} NodoErrorS;

typedef struct Nodoatomo {
    char dato[1]; // Puedes ajustar el tamaño según tus necesidades
    struct Nodoatomo* siguiente;
} Nodoatomo;

%}

%option noyywrap


%{
// Puedes declarar variables globales o incluir encabezados necesarios aquí
// En este caso, usaremos una lista enlazada simple para la tabla de símbolos
NodoIdentificador* listaDeIdentificadores = NULL;
NodoTabla* tablaDeTokens = NULL;
NodoLiteral* tablaDeLiterales = NULL;
NodoError* listaDeErrores = NULL;
NodoErrorS* listaDeErroresS = NULL;
Nodoatomo* listatomos= NULL;

int posicionEnTabla = 0; // Lleva un contador de la posición en la tabla
int posicionEnIdent=0;
int poslit=0;
char c;
int posatom=0;
FILE* yyin;
%}

%%

\n      { yylineno++; return 11;}

[ \t]+ /* Ignorar espacios en blanco, tabuladores y saltos de línea */

"+"       { agregarATabla(0, yytext); agregaratomos("+"); return -1; }
"-"       { agregarATabla(0, yytext); agregaratomos("-");return -1; }
"*"       { agregarATabla(0, yytext); agregaratomos("*");return -1; }
"/"       { agregarATabla(0, yytext); agregaratomos("/");return -1;}
"%"       { agregarATabla(0, yytext); agregaratomos("%");return -1;}

"\&\&"      { agregarATabla(1, "0"); agregaratomos("h"); return 1;}
"\|\|"      { agregarATabla(1, "1"); agregaratomos("j"); return 1;}
"\!"       { agregarATabla(1, "2"); agregaratomos("!");return 1;}

"\=\="    { agregarATabla(2, "0");agregaratomos("e");  return 2; }
"\!\="    { agregarATabla(2, "1");agregaratomos("d");   return 2; }
"\>"     { agregarATabla(2, "2");agregaratomos(">");   return 2; }
"\<"     { agregarATabla(2, "3");agregaratomos("<");   return 2; }
"\>\="    { agregarATabla(2, "4");agregaratomos("m");   return 2; }
"\<\="    { agregarATabla(2, "5");agregaratomos("w");   return 2; }


[0-9]+ { 
            int value = atoi(yytext);
            agregarATabla(3, yytext); // Clase 2 para constantes enteras
            agregaratomos("n"); 
            return 3; // 3 es un identificador único para constantes enteras
            }
"(""+"?[0-9]+")"   {
                       // Ignora los paréntesis y agrega solo el número a la tabla
                       int len = yyleng; // Longitud de yytext incluyendo paréntesis
                       char number[len-2]; // Crea un nuevo array sin los paréntesis
                       strncpy(number, yytext+2, len-3); // Copia el número sin paréntesis y signo
                       number[len-3] = '\0'; // Asegura que el array de caracteres termina con nulo
                       int value = atoi(number);
                       agregarATabla(3, number); // Agrega el número entero a la tabla
                       agregaratomos("n");
                       return 3; 
                    }

"(""-"[0-9]+")"   {
                       // Ignora los paréntesis y agrega el número con signo menos a la tabla
                       int len = yyleng; // Longitud de yytext incluyendo paréntesis
                       char number[len-2]; // Crea un nuevo array sin los paréntesis
                       strncpy(number, yytext+1, len-2); // Copia el número sin paréntesis y con signo menos
                       number[len-2] = '\0'; // Asegura que el array de caracteres termina con nulo
                       int value = atoi(number);
                       agregaratomos("n"); 
                       agregarATabla(3, number); // Agrega el número entero a la tabla
                       return 3;
                    }

"assinado" { agregarATabla(4, "0");agregaratomos("g"); return 4 ; }
"caso"      { agregarATabla(4, "1");agregaratomos("c"); return 4;}
"enquanto"  { agregarATabla(4, "2"); agregaratomos("q"); return 4;}
"fazer"     { agregarATabla(4, "3"); agregaratomos("z"); return 4;}
"flutuador" { agregarATabla(4, "4"); agregaratomos("f"); return 4;}
"inteiro"   { agregarATabla(4, "5"); agregaratomos("i"); return 4;}
"para"      { agregarATabla(4, "6"); agregaratomos("p"); return 4;}
"quebrar"   { agregarATabla(4, "7"); agregaratomos("u"); return 4;}
"retorno"   { agregarATabla(4, "8"); agregaratomos("t"); return 4;}
"se"        { agregarATabla(4, "9"); agregaratomos("s"); return 4;}
"trocar"    { agregarATabla(4, "10"); agregaratomos("b"); return 4;}

"_"[A-Za-z][A-Za-z0-9_]* {
            int posicion = buscarEnIdentificadores(yytext);
            char temp[20];
            if (posicion == -1) {
                // Si no se encuentra, agregar a la lista de identificadores
                sprintf(temp, "%d", posicionEnIdent);
                agregarAIdentificadores(posicionEnIdent,yytext, 5); // Clase 5 para identificadores
                // Luego agregar a la tabla con el valor de la posición en la tabla de símbolos
               
                agregarATabla(5, temp); // Clase 5 para identificadores
                posicion = posicionEnTabla;
                agregaratomos("a"); 
            }
            else{
             sprintf(temp, "%d", posicion);
             agregarATabla(5, temp);
             agregaratomos("a"); 
              }
              return 5;
            }

"{"       { agregarATabla(6, "{");agregaratomos("{");  return 6; }
"}"       { agregarATabla(6, "}");agregaratomos("}");  return 6;}
"("       { agregarATabla(6, "(");agregaratomos("(");  return 6;}
")"       { agregarATabla(6, ")");agregaratomos(")"); return 6;}
";"       { agregarATabla(6, ";");agregaratomos(";"); return 6;}
","       { agregarATabla(6, ",");agregaratomos(","); return 6;}
"["       { agregarATabla(6, "[");agregaratomos("["); return 6;}
"]"       { agregarATabla(6, "]");agregaratomos("]"); return 6;}
":"       { agregarATabla(6, ":");agregaratomos(":"); return 6;}
"#"       { agregarATabla(6, "#");agregaratomos("#"); return 6; }

"="       { agregarATabla(7, "0");agregaratomos("="); return 7; }
"+="      { agregarATabla(7, "1");agregaratomos("x"); return 7;}
"-="      { agregarATabla(7, "2");agregaratomos("y"); return 7;}
"*="      { agregarATabla(7, "3");agregaratomos("k"); return 7;}
"/="      { agregarATabla(7, "4");agregaratomos("r"); return 7;}
"%="      { agregarATabla(7, "5");agregaratomos("o"); return 7; }

\".*\"    {
            
          agregarALiterales(yytext);
          agregaratomos("v"); 
            return 8; // Clase 8 para constantes de cadena
            }
"&"       { agregarATabla(9, "&");agregaratomos("&"); return 9;}
"like"       { agregarATabla(9, "like");agregaratomos("l");return 9;  }

[^a-zA-Z0-9_ \t\n] {
    agregarError(yylineno, "Símbolo no permitido "); return 10;}

[A-Za-z][A-Za-z0-9_]* {
    char mensaje[100]; // Puedes ajustar el tamaño según tus necesidades
    sprintf(mensaje, "Identificador mal construido  %s ", yytext);
    agregarError(yylineno, mensaje);
    return 10;
}

([0-9]+[a-zA-Z_]+|[0-9]+\.[0-9]+|\(\+[0-9]+\.[0-9]+\)|\(\-[0-9]+\.[0-9]+\)|\(\-[0-9]+\.[0-9]+|\(\+[0-9]+\.[0-9]+|\+[0-9]+\.[0-9]+\)|\-[0-9]+\.[0-9]+\))+ {
    agregarError(yylineno, "Constante numérica mal construida  ");
    return 10; // Puedes ajustar el valor de retorno según tus necesidades
}


\"([^"\\]|\\.)*[^"]\" {
    agregarError(yylineno, "  Constante literal mal construida"); return 10;
}

%%

void agregarATabla(int clase, const char* valor);
int buscarEnIdentificadores(const char* nombre);
void agregarAIdentificadores(int posicion, const char* nombre, int tipo);
void agregarALiterales(const char* dato);
void agregarError(int linea, const char* mensaje);


int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Uso: %s archivo_fuente\n", argv[0]);
        return 1;
    }

    FILE* file = fopen(argv[1], "r");
    if (!file) {
        perror("Error al abrir el archivo");
        return 1;
    }

    yyin = file;  
    int token;
while ((token = yylex()) != 0) {
    printf("Token procesado: %d\n", token);
    // Puedes manejar los tokens según sea necesario
} // Muestra la tabla al finalizar el análisis
    fclose(file);
    agregaratomos("$");
    siguiente();
    programa();
    mostrarTablas();
    return 0;
}


void agregarATabla(int clase, const char* valor) {
    NodoTabla* nuevoNodo = (NodoTabla*)malloc(sizeof(NodoTabla));
    nuevoNodo->clase = clase;
    strcpy(nuevoNodo->valor, valor);
    nuevoNodo->siguiente = NULL; // El nuevo nodo será el último, así que su siguiente es NULL

    // Caso especial: lista vacía
    if (tablaDeTokens == NULL) {
        tablaDeTokens = nuevoNodo;
    } else {
        // Recorrer la lista hasta el último nodo
        NodoTabla* actual = tablaDeTokens;
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }

        // Agregar el nuevo nodo al final
        actual->siguiente = nuevoNodo;
    }

    // No es necesario incrementar la posición en la tabla aquí, ya que estás agregando al final
    // posiciónEnTabla++;
}

void agregarError(int linea, const char* mensaje) {
    NodoError* nuevoNodo = (NodoError*)malloc(sizeof(NodoError));
    nuevoNodo->linea = linea;
    strcpy(nuevoNodo->mensaje, mensaje);
    nuevoNodo->siguiente = NULL; // El nuevo nodo será el último, así que su siguiente es NULL

    // Caso especial: lista vacía
    if (listaDeErrores == NULL) {
        listaDeErrores = nuevoNodo;
    } else {
        // Recorrer la lista hasta el último nodo
        NodoError* actual = listaDeErrores;
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }

        // Agregar el nuevo nodo al final
        actual->siguiente = nuevoNodo;
    }
}

void agregarErrorS( int linea, const char* mensaje) {
    NodoErrorS* nuevoNodo = (NodoErrorS*)malloc(sizeof(NodoErrorS));
    nuevoNodo->linea = linea;
    strcpy(nuevoNodo->mensaje, mensaje);
    nuevoNodo->siguiente = NULL; // El nuevo nodo será el último, así que su siguiente es NULL
    // Caso especial: lista vacía
    if (listaDeErroresS == NULL) {
        listaDeErroresS = nuevoNodo;
    } else {
        // Recorrer la lista hasta el último nodo
        NodoErrorS* actual = listaDeErroresS;
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }
        // Agregar el nuevo nodo al final
        actual->siguiente = nuevoNodo;
        
    }
}




void agregarAIdentificadores(int posicion, const char* nombre, int tipo) {
    NodoIdentificador* nuevoNodo = (NodoIdentificador*)malloc(sizeof(NodoIdentificador));
    nuevoNodo->posicion = posicion;
    strcpy(nuevoNodo->nombre, nombre);
    nuevoNodo->tipo = tipo;
    nuevoNodo->siguiente = NULL; // El nuevo nodo será el último, así que su siguiente es NULL

    // Caso especial: lista vacía
    if (listaDeIdentificadores == NULL) {
        listaDeIdentificadores = nuevoNodo;
    } else {
        // Recorrer la lista hasta el último nodo
        NodoIdentificador* actual = listaDeIdentificadores;
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }

        // Agregar el nuevo nodo al final
        actual->siguiente = nuevoNodo;
    }

    posicionEnIdent++;
}


void agregarALiterales(const char* dato) {
    NodoLiteral* nuevoNodo = (NodoLiteral*)malloc(sizeof(NodoLiteral));
    nuevoNodo->posicion = poslit;
    strcpy(nuevoNodo->dato, dato);
    nuevoNodo->siguiente = NULL; // El nuevo nodo será el último, así que su siguiente es NULL

    // Caso especial: lista vacía
    if (tablaDeLiterales == NULL) {
        tablaDeLiterales = nuevoNodo;
    } else {
        // Recorrer la lista hasta el último nodo
        NodoLiteral* actual = tablaDeLiterales;
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }

        // Agregar el nuevo nodo al final
        actual->siguiente = nuevoNodo;
    }

    poslit++;
}

void agregaratomos(const char* dato) {
    Nodoatomo* nuevoNodo = (Nodoatomo*)malloc(sizeof(Nodoatomo));
    strcpy(nuevoNodo->dato, dato);
    nuevoNodo->siguiente = NULL; // El nuevo nodo será el último, así que su siguiente es NULL

    // Caso especial: lista vacía
    if (listatomos == NULL) {
        listatomos = nuevoNodo;
    } else {
        // Recorrer la lista hasta el último nodo
        Nodoatomo* actual = listatomos;
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }

        // Agregar el nuevo nodo al final
        actual->siguiente = nuevoNodo;
    }

}

void mostrarTablas() {
    printf("\nTabla de Tokens:\n");
    NodoTabla* actualTabla = tablaDeTokens;
    while (actualTabla != NULL) {
        printf("Clase: %d, Valor: %s\n", actualTabla->clase, actualTabla->valor);
        actualTabla = actualTabla->siguiente;
    }

    printf("\nTabla de Literales:\n");
    NodoLiteral* actualLiteral = tablaDeLiterales;
    while (actualLiteral != NULL) {
        printf("Posición: %d, Dato: %s\n", actualLiteral->posicion, actualLiteral->dato);
        actualLiteral = actualLiteral->siguiente;
    }

    printf("\nTabla de Identificadores:\n");
    NodoIdentificador* actualIdentificador = listaDeIdentificadores;
    while (actualIdentificador != NULL) {
        printf("Tipo: %d, Valor: %d, Nombre: %s\n", actualIdentificador->tipo, actualIdentificador->posicion, actualIdentificador->nombre);
        actualIdentificador = actualIdentificador->siguiente;
    }
    printf("Posición en lista: %d\n", posicionEnIdent);
    
 printf("\nLista de Errores:\n");
    NodoError* actualError = listaDeErrores;
    while (actualError != NULL) {
        printf("Línea: %d, Mensaje: %s\n", actualError->linea, actualError->mensaje);
        actualError = actualError->siguiente;
    }
 printf("\nLista de ErroresSintacticos:\n");
    NodoErrorS* actualErrors = listaDeErroresS;
    while (actualErrors != NULL) {
        printf("Línea: %d, Mensaje: %s\n", actualErrors->linea, actualErrors->mensaje);
        actualErrors = actualErrors->siguiente;
    }
 printf("\natomos:\n");
    Nodoatomo* actualatomo = listatomos;
    while (actualatomo != NULL) {
        printf("%s",actualatomo->dato);
        actualatomo = actualatomo->siguiente;
    }
    printf("\n");
    
}

void siguientedos(){
    Nodoatomo* actualatomo = listatomos;
    if (actualatomo != NULL) {
        c=actualatomo->dato[0];
        actualatomo = actualatomo->siguiente;
        posatom++;
    }
}



char siguiente(){
    Nodoatomo* actualatomo = listatomos;
    int conti = 0;
    
    while (conti < posatom && actualatomo != NULL) {
        actualatomo = actualatomo->siguiente;
        conti++;
    }
    
    if (conti == posatom && actualatomo != NULL) {
        posatom++;
        return actualatomo->dato[0];
    } 
}


int buscarEnIdentificadores(const char* nombre) {
    NodoIdentificador* actual = listaDeIdentificadores;
    int posicion = 0; // Comienza desde 1
    while (actual != NULL) {
        if (strcmp(actual->nombre, nombre) == 0) {
            return posicion;
        }
        actual = actual->siguiente;
        posicion++;
    }
    return -1; // Retorna -1 si no se encuentra
}

int programa(){
   if(c=='f'||c=='i'||c=='g'){
      func();
      otrafunc();
   }
   else{
      agregarErrorS(posatom,"debe de existir un atomo f o i o g");
      func();
      otrafunc();
   }
}
void otrafunc(){
if(c=='f'||c=='i'||c=='g'){
        func();
        otrafunc();
    }else if (c=='$'){
        return;
    }else {
       agregarErrorS(posatom,"debe de existir un atomo f o i o g");
       return;
    }
}
int func(){
    if(c=='f'||c=='i'||c=='g'){
        tipo();
        if(c=='a'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo a");
            c=siguiente();
        }
        if(c=='('){
            c=siguiente();
        } else{
           agregarErrorS(posatom,"debe de existir un atomo (");
           c=siguiente();
        }
        listarg();
        if(c==')'){
            c=siguiente();
        } else{
           agregarErrorS(posatom,"debe de existir un atomo )");
           c=siguiente();
        }
        if(c=='{'){
            c=siguiente();
        } else{
            agregarErrorS(posatom,"debe de existir un atomo {");
            c=siguiente();
          
        }
        cuerpo();
        if(c=='}'){
            c=siguiente();
        } else{
           agregarErrorS(posatom,"debe de existir un atomo }");
           c=siguiente();
            
        }
    }else{
       agregarErrorS(posatom,"debe de existir un atomo f o i o g");
       tipo();
       listarg();
       cuerpo();
    }
}


 int tipof(){
    if(c=='f'||c=='i'){
        tipo();
    }else if (c=='g'){
        c=siguiente();
    }else{
         agregarErrorS(posatom,"debe de existir un atomo f o i o g ");
         c=siguiente();
    }
}

int listarg(){
    if(c=='f'||c=='i'){
        tipo();
        if (c=='a'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo a");
            c=siguiente();
        }
        otroarg();
    }else if (c==')'){
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo f o i o )");
        return 0;
    }
}

int otroarg(){
    if(c==','){
        c=siguiente ();
        tipo();
        if (c=='a'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo a");
            c=siguiente();
        }
        otroarg();
    }else if (c==')'){
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo , o )"); 
        return 0;  
    }
}

void cuerpo(){
    if(c=='f'||c=='i'){
        listdecl();
        listas();
    }else{
       agregarErrorS(posatom,"debe de existir un atomo f o i");
        listdecl();
        listas();
    }
  }
int listdecl(){
    if(c=='a'||c=='u'||c=='t'||c=='b'||c=='q'||c=='z'||c=='s'||c=='p'||c=='['||c=='}'){
        return 0;
    }else if (c=='f'||c=='i'){
        decl();
        listdecl();
    }else{
         agregarErrorS(posatom,"debe de existir por lo menos un atomo de los siguiente autbqzsp[}"); 
         decl();
         listdecl(); 
    }
}


 void decl(){
    if (c=='f'||c=='i'){
        tipo();
        if (c=='a'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo a"); 
            c=siguiente();
        }
        valorini();
        listvar();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo f o i");
        tipo();
        valorini();
        listvar();
    }
}

void tipo(){
    if (c=='f'){         
        c=siguiente();
    }else if (c=='i'){   
        c=siguiente();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo f o i");
        c=siguiente();
    }
}

int valorini(){
    if(c=='='){
        c=siguiente();
        tipoval();
    }else if (c==','||c==';'){
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo =  O , O ;");
        return 0;
    }
}

int  listvar(){
    if(c==','){
        c=siguiente();        
        if(c=='a'){         
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo a");
            c=siguiente();
        }
        valorini();
        listvar();
    }else if (c==';'){
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo , O ;");
        return 0;
    }
}

void tipoval(){
    if (c=='n'){         
        c=siguiente();
    }else if (c=='v'){   
        c=siguiente();
    }else{
       agregarErrorS(posatom,"debe de existir un atomo n O v");
       c=siguiente();
    }
}

void asig(){
    if(c=='a'){
        c=siguiente();
        oparit();        
        e();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo e");
        c=siguiente();
        oparit();        
        e();
    }
}

void e(){
    if(c=='('||c=='a'||c=='n'||c=='['){
        t();
        ep();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo ( O a O n O [");
        t();
        ep();
    }
}

int ep(){
    if(c=='+'){              
        c=siguiente();
        t();
        ep();
    }else if (c=='-'){       
        c=siguiente();
        t();
        ep();
    }else if(c==')'){        
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo + O - O )");
        return 0;
    }
}

void t(){
    if(c=='('||c=='a'||c=='n'||c=='['){
        f();
        tp();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo ( O a O n O [");
        f();
        tp();
    }
}

 int tp(){
    if(c=='*'){          
        c=siguiente();
        f();
        tp();
    }else if(c=='/'){         
        c=siguiente();
        f();
        tp();
    }else if (c=='%'){        
        c=siguiente();
        f();
        tp();
    }else if (c=='+'||c=='-'||c==')'){        
        return 0;
    }else{
       agregarErrorS(posatom,"debe de existir un atomo * O / O % O + O - O )");
       return 0;
    }
}
//aca tengo duda
 void f(){
    if(c=='('){          
        c=siguiente();
        e();
        if (c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
    }else if(c=='a'){        
        c=siguiente();
    }else if (c=='n'){   
        c=siguiente();
    }else if(c=='['){    
        llama();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo ( O a O n O [");
        llama();
    }
}

void llama(){
    if (c=='['){
        c=siguiente();
        if (c=='a'){
            c=siguiente();
        }else{
          agregarErrorS(posatom,"debe de existir un atomo a");
          c=siguiente();
        }
        if (c=='('){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo (");
             c=siguiente();
        }
        listp();
        if (c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if (c==']'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ]");
             c=siguiente();
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo [");
        c=siguiente();
        listp();
    }
}

void r(){
    if(c=='('||c=='a'||c=='n'||c=='['){          
        r();
        oprel();
        e();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo ( O n O [");
        r();
        oprel();
        e();
    }
}

void oprel(){
    if(c=='>'){         
        c=siguiente();
    }else if(c=='<'){   
        c=siguiente();
    }else if(c=='e'){           
        c=siguiente();
    }else if(c=='d'){   
        c=siguiente();
    }else if(c=='m'){   
        c=siguiente();
    }else if(c=='w'){   
        c=siguiente();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo >  O e O d O m O w");
        c=siguiente();
    }
}

void sent(){
    if(c=='a'){
        asig();
    }else if (c=='u'){
        q();
    }else if (c=='t'){
        ret();
    }else if (c=='b'){
        trocar();
    }else if (c=='q'){
        enq();
    }else if (c=='z'){
        faz();
    }else if (c=='s'){
        faz();
    }else if (c=='p'){
        faz();
    }else if (c=='['){
        llama();
    }else{
         agregarErrorS(posatom,"debe de existir un atomo a  O u O t O b O q O z O s O p O [");
         llama();
    }
}

int listas(){
    if(c=='a'||c=='u'||c=='t'||c=='b'||c=='q'||c=='z'||c=='s'||c=='p'||c=='['){          
        sent();
        listas();
    }else if(c=='#'||c=='}'){    
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo a  O u O t O b O q O z O s O p O [ O # O }");
        return 0;
    }
}

void explogica(){
    if(c=='!'){
        c=siguiente();
        exprel();
    }else if(c=='('||c=='a'||c=='n'||c=='['){
        r();
        explog();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo ! O ( O a O n O [");
        r();
        explog();
    }
}

 int explog(){
    if(c=='h'||c=='j'){
        oplog();
        r();
    }else if(c==')'){
        return 0;
    }else{
        agregarErrorS(posatom,"debe de existir un atomo h O )");
        return 0;
    }
}

void oplog(){
    if(c=='h'){
        c=siguiente();
    }else if(c=='j'){
        c=siguiente();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo h O j");
        c=siguiente();
    }
}

void enq(){
    if(c=='q'){
        c=siguiente();
        if(c=='('){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ( ");
            c=siguiente();   
        }
        explogica();
        if(c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();
        }
        listas();
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();     
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo q");
        c=siguiente();
        explogica();
        listas();
    }
}

void se(){
    if(c=='s'){
        c=siguiente();
        if(c=='('){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo (");
            c=siguiente();
        }
        explogica();
        if(c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
        }
        listas();
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo s");
        c=siguiente();
        explogica();
        listas();
    }
}

void q(){
    if(c=='u'){
        c=siguiente();
        if(c==';'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ;");
             c=siguiente();
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo u");
        c=siguiente();
    }
}

void faz(){
    if(c=='z'){
        c=siguiente();        
        if(c=='#'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();
        }
        listas();
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();
        }
        if(c=='q'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo q");
            c=siguiente();
        }
        if(c=='('){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo (");
            c=siguiente();
        }
        explogica();
        if(c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if(c==';'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ;");
            c=siguiente();
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo z");
        c=siguiente();  
        listas();
         explogica();
    }
}

void ret(){
    if(c=='t'){
        c=siguiente();
        valret();
        if(c==';'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ;");
            c=siguiente();
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo t");
        c=siguiente();
        valret();
    }
}

int valret(){
    if(c=='('||c=='a'||c=='n'||c=='['){
        e();
    }else if(c=='{'){
        c=siguiente();
        expcad();
        if(c=='}'){
            c=siguiente();
        }else{
          agregarErrorS(posatom,"debe de existir un atomo {");
          c=siguiente();
        }
    }else if(c==';'){
        return 0; 
    }else{
        agregarErrorS(posatom,"debe de existir un atomo ( O a O n O [;");
       // e();
        //c=siguiente();
        //expcad();
        return 0;
    }
}

void expcad(){
    if(c=='a'){
        c=siguiente();
        opcad();
    }else if(c=='v'){
        c=siguiente();
        opcad();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo a O v");
         c=siguiente();
        opcad();
    }
}

int opcad(){
    if(c=='l'){
        c=siguiente();
        expcad();
    }else if(c=='h'){
        c=siguiente();
        expcad();
    }else if(c=='}'){
        return 0;
    }else{
       agregarErrorS(posatom,"debe de existir un atomo l O h O }");
        return 0;
    }
}

void para(){
    if(c=='p'){
        c=siguiente();
        if(c=='a'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo a");
            c=siguiente();
        }
        if(c=='['){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo [");
            c=siguiente();
        }
        if(c=='n'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo n");
           c=siguiente();
        }
        if(c==','){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ,");
            c=siguiente();
         }
        if(c=='n'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo n");
            c=siguiente();
        }
        if(c==']'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo ]");
            c=siguiente();
        }
        if(c=='#'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo #");
           c=siguiente();
        }
        listas();
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
             c=siguiente();
        }
    }else{
        agregarErrorS(posatom,"debe de existir un atomo p");
         c=siguiente();
         
         listas();
    }
}

void trocar(){
    if(c=='b'){
        c=siguiente();
        if(c=='('){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo (");
            c=siguiente();
        }
        if(c=='a'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo a");
          c=siguiente();
        }
        if(c==')'){
           c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo )");
           c=siguiente();
        }
        if(c==':'){
            c=siguiente();
        }else{
          agregarErrorS(posatom,"debe de existir un atomo :");
          c=siguiente();
        }
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();
        }
        if(c=='c'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo c");;
            c=siguiente();
        }
        if(c=='('){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo (");
           c=siguiente();
        }
        if(c=='n'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo n");
            c=siguiente();
        }
        if(c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if(c=='{'){
           c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo {");
            c=siguiente();
        }
        listas();
        if(c=='}'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo }");
            c=siguiente();
        }
        casos();
        if(c=='#'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo #");
            c=siguiente();
        }
    }else{
       agregarErrorS(posatom,"debe de existir un atomo b");
       c=siguiente();
       listas();
       casos();
    }
}

int casos(){
    if(c=='#'){
        return 0;
    }else if (c=='c'){
        c=siguiente();
        if(c=='('){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo (");
            c=siguiente();
        }
        if(c=='n'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo n");
           c=siguiente();
        }
        if(c==')'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if(c=='{'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo {");
           c=siguiente();
        }
        listas();
        if(c=='}'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo }");
            c=siguiente();
        }
        casos();
    }else if (c=='('){
        c=siguiente();
        if(c==')'){
           c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");
            c=siguiente();
        }
        if(c=='{'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo {");
            c=siguiente();
        }
        listas();
        if(c=='}'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo )");     
            c=siguiente();
               }
        casos();
    }else {
        agregarErrorS(posatom,"debe de existir un atomo ( O #");
        c=siguiente();
        listas();
        casos();
    }
}

int listp(){
    if(c==')'){
        return 0;
    }else if (c=='('||c=='a'||c=='n'||c=='['){
        e();
        param();
    }else if (c=='{'){
        c=siguiente();
        expcad();
        if (c=='}'){
            c=siguiente();
        }else{
           agregarErrorS(posatom,"debe de existir un atomo }");
           c=siguiente();
        }
        param();
    }else{
       agregarErrorS(posatom,"debe de existir un atomo ( O  { ");
        c=siguiente();
        expcad();
        param();
    }
}


int param(){
    if(c==','){
        c=siguiente();
        listp();
    }else if (c==')'){
        return 0;
    }else{
       agregarErrorS(posatom,"debe de existir un atomo , O  ) ");
       return 0;
    }
}

void oparit(){
    if (c=='='){         
        c=siguiente();
    }else if (c=='x'){   
        c=siguiente();
    }else if(c=='y'){   
        c=siguiente();        
    }else if(c=='k'){    
        c=siguiente();    
    }else if (c=='r'){   
        c=siguiente();    
    }else if (c=='o'){   
        c=siguiente();
    }else{
        agregarErrorS(posatom,"debe de existir un atomo =  O  x O y O  k O r O o");
        c=siguiente();
    }
}

void exprel(){
    if(c=='{'){
        c=siguiente();
        r();
        if(c=='}'){
            c=siguiente();
        }else{
            agregarErrorS(posatom,"debe de existir un atomo }");
            c=siguiente();
        }
    }else if(c=='('||c=='a'||c=='n'||c=='['){
        e();
    }else{
       agregarErrorS(posatom,"debe de existir un atomo {  O  ( O a O  n O [ ");
       e();
    }
}

