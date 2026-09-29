# Block Fusion: juego de bloques en ensamblador x86

Juego de consola inspirado en **2048**, programado íntegramente en **ensamblador x86 de 16 bits** para MS-DOS. El jugador desplaza bloques por un tablero de 7x5 para fusionar los que tienen el mismo valor hasta alcanzar un número objetivo.

Proyecto de la asignatura **Introducción a los Computadores** (Grado en Ingeniería Informática del Software, Universidad de Extremadura).

**Tecnologías:** Ensamblador x86 (16 bits), MS-DOS, interrupciones de BIOS y DOS, emu8086

---

## Cómo se juega

1. Al empezar, se elige el modo:
   - **Debug:** el tablero arranca con valores precargados, útil para probar.
   - **Normal:** el tablero arranca con una fila de valores aleatorios.
2. Se introduce el **valor objetivo**, que debe ser potencia de 2 entre 16 y 2048.
3. En cada turno se introduce un comando.

Se **gana** al conseguir un bloque con el valor objetivo y se **pierde** si algún bloque llega a la fila superior.

### Comandos

| Comando | Acción |
|---|---|
| `B3 DDS` | Mueve el bloque de la fila B, columna 3, siguiendo la ruta indicada |
| `P` | Pasar turno: el tablero sube una fila y aparece una nueva fila aleatoria abajo |
| `N` | Nueva partida |
| `E` | Salir |

Letras de movimiento: `D` derecha, `A` izquierda, `S` abajo, `W` arriba.

Un movimiento es válido si la ruta pasa solo por casillas vacías y termina en un bloque del mismo valor. Al fusionarse, el valor se duplica y los bloques de encima caen para ocupar el hueco.

---

## Aspectos técnicos destacados

- **Tablero como matriz almacenada en un vector** de palabras, con procedimientos de conversión entre coordenadas de fila y columna y posición en memoria.
- **Validación de comandos** carácter a carácter: formato, rangos de fila y columna, y letras de movimiento permitidas.
- **Comprobación de potencia de 2** con la operación a nivel de bit `n AND (n - 1) = 0`.
- **Fusión de bloques** duplicando el valor con desplazamiento de bits (`shl`) y gravedad de los bloques superiores.
- **Generación de valores aleatorios** entre 2 y 16 como potencias de 2.
- **Interfaz de texto** con posicionamiento de cursor, pantalla de inicio en ASCII art y tablero redibujado en cada turno.
- **Código modular** con procedimientos documentados (función, entradas y salidas) y preservación de registros en la pila.

---

## Estructura

| Archivo | Contenido |
|---|---|
| `BlockFusion.asm` | Programa principal y procedimientos del juego |
| `PROCS_std.inc` | Procedimientos de E/S estándar (proporcionados por la asignatura) |
| `PROCS_clase.inc` | Procedimientos auxiliares de clase (proporcionados por la asignatura) |

## Cómo ejecutarlo

1. Instala **emu8086** (Windows) o usa **DOSBox** con un ensamblador compatible.
2. Clona el repositorio:
   ```bash
   git clone https://github.com/jmm-21/block-fusion-asm.git
   ```
3. Abre `BlockFusion.asm` en emu8086, con los `.inc` en la misma carpeta.
4. Pulsa **Emulate** y después **Run**.

---

## Autor

**Jorge Méndez Martínez** 