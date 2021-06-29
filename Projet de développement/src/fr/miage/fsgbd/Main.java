package fr.miage.fsgbd;

import java.lang.reflect.Type;
import java.util.List;

import javax.swing.JTextField;

public class Main {
	// Le délimiteur à utiliser pour séparer les champs
	private static final String delimiter = ";";
	// Le nom du fichier
	private static final String dataFileName = "data.csv";

	public static void main(String args[]) {
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				// On cr�e une nouvelle instance de notre JDialog
				GUI fenetre = new GUI();
				fenetre.setVisible(true);
			}
		});

		
		TestInteger testInt = new TestInteger();
		JTextField txtU = new JTextField("4", 7);
		BTreePlus<Integer> bInt = new BTreePlus<Integer>(Integer.parseInt(txtU.getText()), testInt);
		int nbP = 5;
		int nbS = 7;

		// PARCOURS DANS L'ARBRE
		List<String> resPointeur = bInt.pointeursIndex(nbP);
		if (resPointeur == null)
			System.out.println("La clé numéro " + nbP + " n'a pas été trouvée");
		else
			System.out.println("La clé numéro " + nbP + " a été trouvée. La ligne associée est la suivante : " + resPointeur);
		
		// PARCOURS SEQUENTIEL
		List<String> resSeq = bInt.parcoursSequentiel(nbS);
		if (resSeq == null)
			System.out.println("La clé numéro " + nbS + " n'a pas été trouvée");
		else
			System.out.println("La clé numéro " + nbS + " a été trouvée. La ligne associée est la suivante : " + resSeq);



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
