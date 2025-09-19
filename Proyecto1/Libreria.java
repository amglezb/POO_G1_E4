public class Libreria {
    private Libro[] libros;
    private int contadorLibros;

    public Libreria() {
        this.libros = new Libro[100];
        this.contadorLibros = 0;
    }
    public void agregarLibro(Libro libro) {
        if (contadorLibros < 100) {
            libros[contadorLibros] = libro;
            contadorLibros++;
            System.out.println("Agregado");
        } else { System.out.println("Lleno");
        }
    }
    public void mostrarLibros() {
        if (contadorLibros == 0) {
            System.out.println("La librería está vacía.");
            return;
        }
        System.out.println("\n--- Libros en la Librería ---");
        for (int i = 0; i < contadorLibros; i++) {
            System.out.println((i + 1) + ". " + libros[i]);
        }
    }
    public void eliminarLibroPorPosicion(int posicion) {
        int indice = posicion - 1;
        if (indice >= 0 && indice < contadorLibros) {
            String tituloEliminado = libros[indice].getTitulo();
            for (int i = indice; i < contadorLibros - 1; i++) {
                libros[i] = libros[i + 1];
            }
            contadorLibros--;
            libros[contadorLibros] = null;
            System.out.println("¡Libro '" + tituloEliminado + "' eliminado !");
        } else { System.out.println("Número de posición no válido.");
        }
    }
}