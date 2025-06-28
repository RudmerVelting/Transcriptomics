## Identificatie van genen binnen de hsa04660 KEGG-Pathway. Adaptive Immune Response in Rheumatoïd Arthritis

Tijdens deze casus is er uit een getrimde database een count matrix gemaakt waarmee een Gene Ontology Analysis en KEGG-Pathway analysis is uitgevoerd.

## 📁 Datastructuur

- `data/raw/` – ruwe data van de patiënten 
- `data/processed` - geselecteerde data door middel van scripts
- `scripts/` – dataverwerking
- `resultaten/` - grafieken en tabellen
- `bronnen/` - de bronnenlijst
- `README.md` - dit document
- `assets/` - behind the scenes spul
- `data_stewardship/` - Voor de competentie beheren ga je aantonen dat je projectgegevens kunt beheren met behulp van GitHub. In deze folder kan je hulpvragen terugvinden om je op gang te helpen met de uitleg van data stewardship. 


## 🦴 Inleiding

Reumatoïde Artritis is een auto-immuunziekte, wat betekent dat jou lichaam wordt aangevallen door het eigen immuunsysteem. Hierbij komen o.a. ontstekingseiwitten vrij, wat kan zorgen voor ontstekingen in de gewrichten. 
Wereldwijd waren er in 2020 ongeveer 17,6 miljoen gevallen van rheuma, in 2050 wordt verwacht dat dit nummer stijgt naar 31,7 miljoen [GBD 2021 Rheumatoid Arthritis Collaborators, 2023](bronnen/1-s2.0-S2665991323002114-main.pdf).  
De oorzaak van Reumatoïde Artritis is onbekend, maar sinds het onderzocht word zijn er verschillende risicofactoren vastgezet zoals geslacht, leeftijd, overgewicht en genetische aanleg [Mayo Clinic, april 2025](https://www.mayoclinic.org/diseases-conditions/rheumatoid-arthritis/symptoms-causes/syc-20353648).  
Er is momenteel geen genezende behandeling beschikbaar, daarom is het belangrijk om precies te weten hoe dat deze ziekte werkt. In dit onderzoek wordt met behulp van transcriptomics onderzocht welk effect Reumatoïde Artritis heeft op de expressie van genen in de hsa04660 KEGG-Pathway.
Er wordt dan gekeken naar hoeveel genen er in totaal omhoog of omlaag gereguleerd worden, daarnaast wordt er ook gekeken naar de biologische processen en om zo hopelijk beter de ziekte te begrijpen en hopelijk ooit een medicijn te vinden.

## 💡 Methode

Om te onderzoeken welke genen een andere expressie vertonen bij Rheuma patienten, is er patiëntendata van acht deelnemers uit het synoviumbiopten genomen. Hiervan warem vier deelnemers gezond verklaard, de andere 4 patiënten hadden langer dan twaalf maanden Reumatoïde Artritis.
Alle patiënten waren vrouwen en de behandelgroep was gemiddeld ouder dan de controlegroep. De data is ook visueel te zien in [deze tabel](assets/ruwe_data_deelnemers.csv). 
De route van data-analyse is met behulp van deze [flowchart](assets/flowchard.PNG) algemeen weergeven. Hieronder worden ze in meer diepte uitgelegd.

De reads zijn als eerste gemapt tegen het [menselijk genoom versie GCF_000001405.40](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/). Hiervoor is de package [Rsubread_2.22.0](bronnen/Rsubread.pdf) gebruikt. Na het mappen is van de data een count matrix gemaakt met [Rsamtools_2.22.0](bronnen/Rsamtools.pdf). Daarna is er een [DESeq21.46.0](bronnen/DESeq2.pdf) analyse gedaan om de significante resultaten in een [tabel](resultaten/) te zetten. Met de resultaten van de DESeq2 analyse is een Volcanoplot, een Gene Ontology Enrichment Analysis en een KEGG-Pathway analysis gedaan. De **Vulkaanplot** is met behulp van [EnhancedVolcano v1.26.0](https://bioconductor.org/packages/release/bioc/html/EnhancedVolcano.html) gemaakt, dit is gedaan om significante resultaten te visualiseren. Daarna is de **GO-analyse** met behulp van [goseq v1.60.0](https://bioconductor.org/packages/release/bioc/html/goseq.html) uitgevoerd. Met behulp van de resultaten van de GO-analyse kan daarna een KEGG-Pathway geselecteerd worden voor de **KEGG-analyse**. Hierbij is besloten om hsa04660 te analyseren, wat een pathway is in de adaptive immune response. Dit is gedaan met de [pathview](https://bioconductor.org/packages/release/bioc/html/pathview.html) library.

## 📈 Resultaten

Om te onderzoeken of dat Reumatoïde artritis invloed heeft op de expressie van genen is er een DESeq-analyse uitgevoerd. De resultaten hiervan zijn beschikbaar in [deze tabel](resultaten/DESeqAnalysis.csv). Hierin zijn alle genen met een p waarde en foldchange zichtbaar. 

Een bijbehorende [volcanoplotplot](resultaten/vulcano_plot.png) toont de log2FC tegenover de log10p-waarde. In deze volcanoplot zijn beide groene en rode punten aangegeven. De groene punten zijn genen die biologisch significant zijn, de rode punten zijn genen die biologisch significant én statistisch significant zijn. Daarnaast zijn er, uit de significante resultaten, 2487 downregulated genen en 2085 upregulated genen gevonden, zoals te zien is in onderstaande tabel.

| Regulation Direction | n genes   |
| Downregulated        | 2487      |
| Upregulated          | 2085      |

De [GO-analyse](resultaten/GO-analyse.csv) toont dat het proces *Adaptive immune response* (GO:0002250) de laagste p-waarde had [p = 0.004].

De KEGG-pathwayanalyse van [hsa04612](resultaten/hsa04612.png) laat zien dat veel genen in deze pathway **neerwaarts gereguleerd** zijn (groen gemarkeerd).

## 📌 Conclusie

Uit de resultaten is gebleken dat Reumatoïde Artritis invloed heeft op de expressie van meerdere genen. De KEGG-pathway hsa04660 adaptive immune response pathway codeert voor T-cell receptoren. Veranderingen in T-cell receptoren worden geassocieerd met rheuma 
  [X.Zhang (2020)](https://www.sciencedirect.com/science/article/abs/pii/S0896841120300457?via%3Dihub). overeenkomt met eerdere bevindingen waarin de expressie van de pathway ook afneemt [Huang et al., 2023](bronnen/TCRregulation.pdf). Voor vervolgonderzoek zou een meer gelijke verdeling tussen de controle- en behandelgroep een optie zijn, zo kunnen deze factoren geen invloed hebben op de resultaten.

Clone the repository:

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
