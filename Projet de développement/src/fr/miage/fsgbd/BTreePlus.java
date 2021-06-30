package fr.miage.fsgbd;

import javax.swing.tree.DefaultMutableTreeNode;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Galli Gregory, Mopolo Moke Gabriel
 * @param <Type>
 */
public class BTreePlus<Type> implements java.io.Serializable {
    Noeud<Type> racine;

    public BTreePlus(int u, Executable e) {
        racine = new Noeud<Type>(u, e, null);
    }

    public void afficheArbre() {
        racine.afficheNoeud(true, 0);
    }

    /**
     * Méthode récursive permettant de récupérer tous les noeuds
     *
     * @return DefaultMutableTreeNode
     */
    public DefaultMutableTreeNode bArbreToJTree() {
        return bArbreToJTree(racine);
    }

    private DefaultMutableTreeNode bArbreToJTree(Noeud<Type> root) {
        StringBuilder txt = new StringBuilder();
        for (Type key : root.keys)
            txt.append(key.toString()).append(" ");

        DefaultMutableTreeNode racine2 = new DefaultMutableTreeNode(txt.toString(), true);
        for (Noeud<Type> fil : root.fils)
            racine2.add(bArbreToJTree(fil));

        return racine2;
    }

    public boolean addValeur(Type valeur) {
        System.out.println("Ajout de la valeur : " + valeur.toString());
        if (racine.contient(valeur) == null) {
            Noeud<Type> newRacine = racine.addValeur(valeur);
            if (racine != newRacine)
                racine = newRacine;
            return true;
        }
        return false;
    }

    public void removeValeur(Type valeur) {
        System.out.println("Retrait de la valeur : " + valeur.toString());
        if (racine.contient(valeur) != null) {
            Noeud<Type> newRacine = racine.removeValeur(valeur, false);
            if (racine != newRacine)
                racine = newRacine;
        }
    }

    GUI gui = new GUI();
    List<List<String>> data = gui.getData();
    // ArrayList<Noeud<Type>> fils = racine.getFils();

    // se balader dans l'arbre et recuperer les index pour les associer à des
    // pointeurs
    public List<String> pointeursIndex(Type index, Noeud<Type> arbre) {
        // concept : parcourir l'arbre de la racine jusqu'aux feuilles, si clé trouvée
        // alors je renvoie les données
        // vérifier dans l'arbre
        List<String> donnee = null;
        if (arbre.keys.contains(index)) {
            int i = (int) index;
            donnee = data.get(i);
        } else {
            for (Noeud<Type> f : arbre.fils) {
                donnee = pointeursIndex(index, f);
                if (donnee!=null){
                    return donnee;
                }
            }
        }
        return donnee;
    }

    public List<String> parcoursSequentiel(int index) {
        // concept : parcourir le fichier data, si clé trouvée alors je renvoie les
        // données
        // passer d'une ligne à l'autre et verifier si ca correspond
        List<String> donnee = null;
        for (int i = 0; i < data.size(); i++) {
            if (index == i) {
                donnee = data.get(i);
            }
        }
        return donnee;
    }
}
