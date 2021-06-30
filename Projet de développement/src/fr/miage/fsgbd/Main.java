package fr.miage.fsgbd;


import java.util.List;

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
