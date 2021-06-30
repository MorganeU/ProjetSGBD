package fr.miage.fsgbd;

import java.lang.reflect.Type;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JTextField;

public class Main {

	static GUI fenetre = new GUI();
	static List<List<String>> data = fenetre.getData();

	public static void main(String args[]) {
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				// On cr�e une nouvelle instance de notre JDialog
				fenetre.setVisible(true);
			}
		});

		Timer t = new Timer();
		t.schedule(new TimerTask() {
			public void run() {
				if (fenetre.getDataBeenImported()) {
					System.out.println("");
					System.out.println("Partie recherches :");
					// fonctions de recherches lancées lorsque les données d'un fichier ont été
					// importées
					// on choisi quelle clé on veut rechercher
					Integer nbP = 5; // pour parcours dans l'arbre
					int nbS = 120; // pour parcours sequentiel

					

					// 100 RECHERCHES
					System.out.println("");
					System.out.println("Temps de recherches :");
					int min = 0;
					int max = data.size() * 2;

					// PARCOURS DANS L'ARBRE
					// long startArbre = System.nanoTime();
					// for (int i = 0; i <= 100; i++) {
					// int cleArbre = min + (int) (Math.random() * ((max - min)));
					// List<String> seq = bInt.parcoursSequentiel(cleArbre);
					// }
					// long endArbre = System.nanoTime();
					// long timeArbre = (endArbre - startArbre);
					// System.out.println(
					// "Pour 100 recherches, en utilisant un parcours dans l'arbre, on obtient un
					// temps d'éxécution de : "
					// + timeArbre/1000000 + " millisecondes");

					// PARCOURS SEQUENTIEL
					// long startSeq = System.nanoTime();
					// long[] temps;
					// for (int i = 0; i <= 100; i++) {
					// 	int cleSeq = min + (int) (Math.random() * ((max - min)));
					// 	List<String> seq = bInt.parcoursSequentiel(cleSeq);
					// }
					// long endSeq = System.nanoTime();
					// long timeSeq = (endSeq - startSeq);
					// System.out.println(
					// 		"Pour 100 recherches, en utilisant un parcours séquentiel, on obtient un temps d'éxécution de : "
					// 				+ timeSeq / 1000000 + " millisecondes");
					
					// STATISTIQUES
					System.out.println("");
					System.out.println("Statistiques :");
					// temps minimum 
					
					// temps maximum 

					// temps moyen


					// On arrete l'execution du timer puisqu'il a été appelé une fois déjà				
					t.cancel();
				}
			}
		}, 0, 2000); 


		/*
		 * TestInteger testInt = new TestInteger(); fr.miage.fsgbd.BTreePlus<Integer>
		 * bInt = new fr.miage.fsgbd.BTreePlus<Integer>(2, 4, testInt);
		 * 
		 * 
		 * int valeur; for(int i=0; i < 200; i++) { valeur =(int) (Math.random() * 250);
		 * System.out.println("valeur " + valeur + " " + i ); bInt.addValeur(valeur);
		 * bInt.afficheArbre();
		 * 
		 * }
		 */

		/*
		 * TestString test = new TestString(); Noeud<String> noeud = new
		 * Noeud<String>(2, 5,test, null); Noeud<String> noeud1 = new Noeud<String>(2,
		 * 5,test, null); Noeud<String> noeud2 = new Noeud<String>(2, 5,test, null);
		 */
		// Charge les données à partir d'un fichier CSV

	}
}
