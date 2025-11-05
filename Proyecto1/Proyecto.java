import java.util.Scanner;

public class Proyecto {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Libreria miLibreria = new Libreria();
        int opcion = 0;
        while (opcion != 4) {
            System.out.println("\n--- MENÚ DE LA LIBRERÍA ---");
            System.out.println("1. Agregar libro");
            System.out.println("2. Mostrar todos los libros");
            System.out.println("3. Eliminar libro por posición");
            System.out.println("4. Salir");
            System.out.print("Elige una opción: ");
            opcion = scanner.nextInt();
            scanner.nextLine();
            switch (opcion) {
                case 1:
                    System.out.print("Introduce el título del libro: ");
                    String titulo = scanner.nextLine();
                    System.out.print("Introduce el autor del libro: ");
                    String autor = scanner.nextLine();
                    Libro nuevoLibro = new Libro(titulo, autor);
                    miLibreria.agregarLibro(nuevoLibro);
                    break;
                case 2:
                    miLibreria.mostrarLibros();
                    break;
                case 3:
                    miLibreria.mostrarLibros();
                    System.out.print("Introduce el número del libro que deseas eliminar: ");
                    int posicion = scanner.nextInt();
                    scanner.nextLine();
                    miLibreria.eliminarLibroPorPosicion(posicion);
                    break;
                case 4:
                    System.out.println("👋 ¡Hasta luego!");
                    break;
                default:
                    System.out.println("Opción no válida.");
                    break;
            }
        }
        scanner.close();
    }
}