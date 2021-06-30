package fr.miage.fsgbd;

import javax.swing.*;
import javax.swing.tree.DefaultTreeModel;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
// import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.io.BufferedReader;
import java.io.FileReader;

/**
 * @author Galli Gregory, Mopolo Moke Gabriel
 */
public class GUI extends JFrame implements ActionListener {
    TestInteger testInt = new TestInteger();
    BTreePlus<Integer> bInt;
    private JButton buttonClean, buttonRemove, buttonLoad, buttonSave, buttonAddMany, buttonAddItem, buttonRefresh,
            addFile;
    private JTextField txtNbreItem, txtNbreSpecificItem, txtU, txtFile, removeSpecific;
    private final JTree tree = new JTree();

    // Le délimiteur à utiliser pour séparer les champs
    private static final String delimiter = ";";
    // Le nom du fichier
    private static final String dataFileName = "data.csv";
    // Récupère les données du CSV
    List<List<String>> data = loadData(dataFileName, delimiter);

    public List<List<String>> getData() {
        // On retire la première ligne qui contient les colonnes
        data.remove(0);
        return data;
    }

    public GUI() {
        super();
        build();
    }

    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == buttonLoad || e.getSource() == buttonClean || e.getSource() == buttonSave
                || e.getSource() == buttonRefresh) {
            if (e.getSource() == buttonLoad) {
                BDeserializer<Integer> load = new BDeserializer<Integer>();
                bInt = load.getArbre(txtFile.getText());
                if (bInt == null)
                    System.out.println("Echec du chargement.");

            } else if (e.getSource() == buttonClean) {
                if (Integer.parseInt(txtU.getText()) < 2)
                    System.out.println("Impossible de créer un arbre dont le nombre de clés est inférieur à 2.");
                else
                    bInt = new BTreePlus<Integer>(Integer.parseInt(txtU.getText()), testInt);
            } else if (e.getSource() == buttonSave) {
                BSerializer<Integer> save = new BSerializer<Integer>(bInt, txtFile.getText());
            } else if (e.getSource() == buttonRefresh) {
                tree.updateUI();
            }
        } else {
            if (bInt == null)
                bInt = new BTreePlus<Integer>(Integer.parseInt(txtU.getText()), testInt);

            if (e.getSource() == buttonAddMany) {
                for (int i = 0; i < Integer.parseInt(txtNbreItem.getText()); i++) {
                    int valeur = (int) (Math.random() * 10 * Integer.parseInt(txtNbreItem.getText()));
                    boolean done = bInt.addValeur(valeur);
                    /*
                     * On pourrait forcer l'ajout mais on risque alors de tomber dans une boucle
                     * infinie sans "r?gle" faisant sens pour en sortir
                     * 
                     * while (!done) { valeur =(int) (Math.random() * 10 *
                     * Integer.parseInt(txtNbreItem.getText())); done = bInt.addValeur(valeur); }
                     */
                }

            } else if (e.getSource() == buttonAddItem) {
                if (!bInt.addValeur(Integer.parseInt(txtNbreSpecificItem.getText())))
                    System.out.println("Tentative d'ajout d'une valeur existante : " + txtNbreSpecificItem.getText());
                txtNbreSpecificItem.setText(String.valueOf(Integer.parseInt(txtNbreSpecificItem.getText()) + 2));

            } else if (e.getSource() == buttonRemove) {
                bInt.removeValeur(Integer.parseInt(removeSpecific.getText()));

            } else if (e.getSource() == addFile) {
                // Appelée qd on appuie sur le bouton pour charger un fichier
                // On retire la première ligne qui contient les colonnes
                data.remove(0);
                // On créé les index et on les met dans le B arbre
                List<Integer> index = new ArrayList<>();
                for (int i = 0; i < data.size(); i++) {
                    index.add(i);
                    boolean done = bInt.addValeur(i);
                }

                // PARTIE RECHERCHES
                System.out.println("");
                System.out.println("Partie recherches :");

                // PARCOURS DANS L'ARBRE
                System.out.println("PARCOURS DANS L'ARBRE");
                int nbP = 300;
                List<String> resPointeur = bInt.pointeursIndex(nbP, bInt.racine);
                if (resPointeur == null)
                    System.out.println("La clé numéro " + nbP + " n'a pas été trouvée");
                else
                    System.out.println("La clé numéro " + nbP + " a été trouvée. La ligne associée est la suivante : "
                            + resPointeur);

                // PARCOURS SEQUENTIEL
                System.out.println("PARCOURS SEQUENTIEL");
                int nbS = 300;
                List<String> resSeq = bInt.parcoursSequentiel(nbS);
                if (resSeq == null)
                    System.out.println("La clé numéro " + nbS + " n'a pas été trouvée");
                else
                    System.out.println(
                            "La clé numéro " + nbS + " a été trouvée. La ligne associée est la suivante : " + resSeq);

                // STATISTIQUES
                statistiques();
            }
        }

        tree.setModel(new DefaultTreeModel(bInt.bArbreToJTree()));
        for (int i = 0; i < tree.getRowCount(); i++)
            tree.expandRow(i);

        tree.updateUI();
    }

    private void build() {
        setTitle("Indexation - B Arbre");
        setSize(760, 760);
        setLocationRelativeTo(this);
        setResizable(false);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setContentPane(buildContentPane());
    }

    private JPanel buildContentPane() {
        GridBagLayout gLayGlob = new GridBagLayout();

        JPanel pane1 = new JPanel();
        pane1.setLayout(gLayGlob);

        GridBagConstraints c = new GridBagConstraints();
        c.fill = GridBagConstraints.HORIZONTAL;
        c.insets = new Insets(0, 5, 2, 0);

        JLabel labelU = new JLabel("Nombre max de clés par noeud (2m): ");
        c.gridx = 0;
        c.gridy = 1;
        c.weightx = 1;
        pane1.add(labelU, c);

        txtU = new JTextField("4", 7);
        c.gridx = 1;
        c.gridy = 1;
        c.weightx = 2;
        pane1.add(txtU, c);

        JLabel labelBetween = new JLabel("Nombre de clefs à ajouter:");
        c.gridx = 0;
        c.gridy = 2;
        c.weightx = 1;
        pane1.add(labelBetween, c);

        txtNbreItem = new JTextField("10000", 7);
        c.gridx = 1;
        c.gridy = 2;
        c.weightx = 1;
        pane1.add(txtNbreItem, c);

        buttonAddMany = new JButton("Ajouter n éléments aléatoires à l'arbre");
        c.gridx = 2;
        c.gridy = 2;
        c.weightx = 1;
        c.gridwidth = 2;
        pane1.add(buttonAddMany, c);

        JLabel labelSpecific = new JLabel("Ajouter une valeur spécifique:");
        c.gridx = 0;
        c.gridy = 3;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(labelSpecific, c);

        txtNbreSpecificItem = new JTextField("50", 7);
        c.gridx = 1;
        c.gridy = 3;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(txtNbreSpecificItem, c);

        buttonAddItem = new JButton("Ajouter l'élément");
        c.gridx = 2;
        c.gridy = 3;
        c.weightx = 1;
        c.gridwidth = 2;
        pane1.add(buttonAddItem, c);

        JLabel labelRemoveSpecific = new JLabel("Retirer une valeur spécifique:");
        c.gridx = 0;
        c.gridy = 4;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(labelRemoveSpecific, c);

        removeSpecific = new JTextField("54", 7);
        c.gridx = 1;
        c.gridy = 4;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(removeSpecific, c);

        buttonRemove = new JButton("Supprimer l'élément n de l'arbre");
        c.gridx = 2;
        c.gridy = 4;
        c.weightx = 1;
        c.gridwidth = 2;
        pane1.add(buttonRemove, c);

        JLabel labelFilename = new JLabel("Nom de fichier : ");
        c.gridx = 0;
        c.gridy = 5;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(labelFilename, c);

        txtFile = new JTextField("arbre.abr", 7);
        c.gridx = 1;
        c.gridy = 5;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(txtFile, c);

        buttonSave = new JButton("Sauver l'arbre");
        c.gridx = 2;
        c.gridy = 5;
        c.weightx = 0.5;
        c.gridwidth = 1;
        pane1.add(buttonSave, c);

        buttonLoad = new JButton("Charger l'arbre");
        c.gridx = 3;
        c.gridy = 5;
        c.weightx = 0.5;
        c.gridwidth = 1;
        pane1.add(buttonLoad, c);

        buttonClean = new JButton("Reset");
        c.gridx = 2;
        c.gridy = 6;
        c.weightx = 1;
        c.gridwidth = 2;
        pane1.add(buttonClean, c);

        buttonRefresh = new JButton("Refresh");
        c.gridx = 2;
        c.gridy = 7;
        c.weightx = 1;
        c.gridwidth = 2;
        pane1.add(buttonRefresh, c);

        // pour ajouter un bouton pour importer un fichier
        addFile = new JButton("Charger un fichier");
        c.gridx = 0;
        c.gridy = 7;
        c.weightx = 1;
        c.gridwidth = 1;
        pane1.add(addFile, c);

        c.fill = GridBagConstraints.HORIZONTAL;
        c.ipady = 400; // reset to default
        c.weighty = 1.0; // request any extra vertical space
        c.gridwidth = 4; // 2 columns wide
        c.gridx = 0;
        c.gridy = 8;

        JScrollPane scrollPane = new JScrollPane(tree);
        pane1.add(scrollPane, c);

        tree.setModel(new DefaultTreeModel(null));
        tree.updateUI();

        txtNbreItem.addActionListener(this);
        buttonAddItem.addActionListener(this);
        buttonAddMany.addActionListener(this);
        buttonLoad.addActionListener(this);
        buttonSave.addActionListener(this);
        buttonRemove.addActionListener(this);
        buttonClean.addActionListener(this);
        buttonRefresh.addActionListener(this);
        addFile.addActionListener(this);

        return pane1;
    }

    // Charge les données à partir d'un fichier CSV
    public List<List<String>> loadData(String dataFileName, String delimiter) {
        List<List<String>> data = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(dataFileName))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split(delimiter);
                data.add(Arrays.asList(values));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return data;
    }

    public void statistiques() {
        // 100 RECHERCHES
        System.out.println("");
        System.out.println("Temps de recherches :");
        int min = 0;
        int max = data.size() * 2;

        // PARCOURS DANS L'ARBRE
        long startArbre = System.nanoTime();
        for (int i = 0; i < 100; i++) {
            int cleArbre = min + (int) (Math.random() * ((max - min)));
            List<String> arb = bInt.pointeursIndex(cleArbre, bInt.racine);
        }
        long endArbre = System.nanoTime();
        long timeArbre = (endArbre - startArbre);
        System.out.println(
                "Pour 100 recherches, en utilisant un parcours dans l'arbre, on obtient un temps d'éxécution de : "
                        + timeArbre / 1000000 + " millisecondes");

        // PARCOURS SEQUENTIEL
        long startSeq = System.nanoTime();
        for (int i = 0; i < 100; i++) {
            int cleSeq = min + (int) (Math.random() * ((max - min)));
            List<String> seq = bInt.parcoursSequentiel(cleSeq);
        }
        long endSeq = System.nanoTime();
        long timeSeq = (endSeq - startSeq);
        System.out.println(
                "Pour 100 recherches, en utilisant un parcours séquentiel, on obtient un temps d'éxécution de : "
                        + timeSeq / 1000000 + " millisecondes");

        // STATISTIQUES
        System.out.println("");
        System.out.println("Statistiques :");
        // PARCOURS DANS L'ARBRE
        double[] tempsArbre = new double[100];
        for (int i = 0; i < 100; i++) {
            double tempsStartArbre = System.nanoTime();
            int cleArbre = min + (int) (Math.random() * ((max - min)));
            List<String> arb = bInt.pointeursIndex(cleArbre, bInt.racine);
            double tempsEndArbre = System.nanoTime();
            tempsArbre[i] = tempsEndArbre - tempsStartArbre;
        }
        // PARCOURS SEQUENTIEL
        double[] tempsSeq = new double[100];
        for (int i = 0; i < 100; i++) {
            double tempsStartSeq = System.nanoTime();
            int cleSeq = min + (int) (Math.random() * ((max - min)));
            List<String> seq = bInt.parcoursSequentiel(cleSeq);
            double tempsEndSeq = System.nanoTime();
            tempsSeq[i] = tempsEndSeq - tempsStartSeq;
        }
        // temps minimum
        System.out.println("TEMPS MINIMUMS");
        double minArbre = minimum(tempsArbre);
        double minSeq = minimum(tempsSeq);
        System.out.println(
                "Le temps minimum pour une recherche dans l'arbre est de : " + minArbre / 1000000 + " millisecondes");
        System.out.println(
                "Le temps minimum pour une recherche séquentielle est de : " + minSeq / 1000000 + " millisecondes");
        // temps maximum
        System.out.println("TEMPS MAXIMUMS");
        double maxArbre = maximum(tempsArbre);
        double maxSeq = maximum(tempsSeq);
        System.out.println(
                "Le temps maximum pour une recherche dans l'arbre est de : " + maxArbre / 1000000 + " millisecondes");
        System.out.println(
                "Le temps maximum pour une recherche séquentielle est de : " + maxSeq / 1000000 + " millisecondes");
        // temps moyen
        System.out.println("TEMPS MOYENS");
        double moyArbre = moyenne(tempsArbre);
        double moySeq = moyenne(tempsSeq);
        System.out.println(
                "Le temps moyen pour une recherche dans l'arbre est de : " + moyArbre / 1000000 + " millisecondes");
        System.out.println(
                "Le temps moyen pour une recherche séquentielle est de : " + moySeq / 1000000 + " millisecondes");
    }

    public double minimum(double[] list) {
        double min = list[0];
        for (int i = 1; i < list.length; i++) {
            if (list[i] < min) {
                min = list[i];
            }
        }
        return min;
    }

    public double maximum(double[] list) {
        double max = list[0];
        for (int i = 1; i < list.length; i++) {
            if (list[i] > max) {
                max = list[i];
            }
        }
        return max;
    }

    public double moyenne(double[] list) {
        double moy = 0;
        for (int i = 1; i < list.length; i++) {
            moy = moy + list[i];
        }
        moy = moy / list.length;
        return moy;
    }
}
