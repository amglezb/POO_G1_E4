package Figuras;

import java.util.Scanner;

public class Figuras {
    final static double PI = 3.1416;
    public static void main(String[] args) {
        int op;
        Scanner s = new Scanner(System.in);
        do {
            System.out.println("Elige una opcion: ");
            System.out.println("1.- Area del Circulo");
            System.out.println("2.- Area del Triangulo");
            System.out.println("3.- Area del Cuadrado");
            System.out.println("4.- Salir");
            op = s.nextInt();
            switch (op) {
                case 1:
                    System.out.println("Seleccionaste Circulo");
                    System.out.println("El area del Circulo es " + areaCirculo(15));
                    break;
                case 2:
                    System.out.println("Seleccionaste Triangulo");
                    System.out.println("El area del Triangulo es " + areaTriangulo(8, 3));
                    break;
                case 3:
                    System.out.println("Seleccionaste Cuadrado");
                    System.out.println("El area del Cuadrado es " + areaCuadrado(10));
                    break;
                case 4:
                    System.out.println("Fin del programa");
                    break;
                default:
                    System.out.println("Opcion inválida");
                    continue;
            }
        } while (op != 4);
        s.close();
    }

    public static double areaCirculo(double radio) {
        return PI * radio * radio;
    }

    public static double areaTriangulo(double base, double altura) {
        return (base * altura) / 2;
    }
    public static double areaCuadrado(double lado) {
        return lado * lado;
    }

}