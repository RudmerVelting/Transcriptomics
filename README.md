## Identificatie van genen binnen de hsa04660 KEGG-Pathway. Adaptive Immune Response in Rheumatoïd Arthritis

Tijdens deze casus is er uit een getrimde database een count matrix gemaakt waarmee een Gene Ontology Analysis en KEGG-Pathway analysis is uitgevoerd.

## 📁 Datastructuur

- `data/raw/` – ruwe data van de patiënten 
- `data/processed` - geselecteerde data door middel van scripts
- `scripts/` – 
- `resultaten/` - grafieken en tabellen
- `bronnen/` - de bronnenlijst
- `README.md` - dit document
- `assets/` - behind the scenes spul
- `data_stewardship/` - Voor de competentie beheren ga je aantonen dat je projectgegevens kunt beheren met behulp van GitHub. In deze folder kan je hulpvragen terugvinden om je op gang te helpen met de uitleg van data stewardship. 


## 🦴 Inleiding

Reumatoïde Artritis is een auto-immuunziekte. Dit betekent dat het immuunsysteem je lichaam aanvalt. Hierbij komen o.a. ontstekingseiwitten vrij, wat vaak leidt tot ontstekingen in de gewrichten. 
Ongeveer 0,5–1% van de wereldbevolking heeft Reumatoïde Artritis. Dit percentage verschilt per land [Silman & Pearson, 2002](bronnen/Epidemiology_and_genetics_of_rheumatoid_arthritis.pdf).  
De oorzaak van Reumatoïde Artritis is onbekend, maar er zijn verschillende risicofactoren, zoals geslacht, leeftijd, genetische aanleg en overgewicht [Mayo Clinic, april 2025](https://www.mayoclinic.org/diseases-conditions/rheumatoid-arthritis/symptoms-causes/syc-20353648?p=1).  
De ziekte kent diverse symptomen zoals stijve en/of gezwollen gewrichten, vermoeidheid en verminderde mobiliteit [ClevelandClinic, juni 2024](https://my.clevelandclinic.org/health/diseases/4924-rheumatoid-arthritis).  
Er is momenteel geen genezende behandeling beschikbaar, daarom is het belangrijk om precies te weten hoe dat deze ziekte werkt. In dit onderzoek wordt met behulp van transcriptomics onderzocht welk effect Reumatoïde Artritis heeft op de expressie van genen en pathways.Er wordt dan gekeken naar hoeveel genen er in totaal omhoog of omlaag gereguleerd worden, daarnaast wordt er ook gekeken naar de biologische processen en pathways om zo hopelijk beter de ziekte te begrijpen en hopelijk ooit een medicijn te vinden.

## 💡 Methode

Om te onderzoeken welke genen een andere expressie vertonen bij Rheuma patienten, is er patiëntendata van acht deelnemers uit het synoviumbiopten. Hiervan warem vier deelnemers gezond verklaard, de andere 4 patiënten hadden langer dan twaalf maanden Reumatoïde Artritis.
Alle patiënten waren vrouwen. De behandelgroep was gemiddeld ouder dan de controlegroep, zoals te zien in [deze tabel](assets/ruwe_data_deelnemers.csv). De methoden van de data-analyses zijn in deze [flowchart](assets/flowchard.PNG) in een versimpelde manier weergeven. Hieronder worden ze in meer diepte uitgelegd.

De reads zijn als eerste gemapt tegen het [menselijk genoom versie GCF_000001405.40](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/) met [dit script](scripts/mapping_data.R). hiervoor is de package [Rsubread versie 2.22.1](https://bioconductor.org/packages/release/bioc/html/Rsubread.html) gebruikt. Na het mappen is van de data een count matrix gemaakt met [Rsamtools versie 2.24.0](https://bioconductor.org/packages/release/bioc/html/Rsamtools.html) volgens [dit script](scripts/count_matrix.R). Daarna is er een [DESeq2 versie 1.48.1](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) analyse gedaan om de significante resultaten in een [deze tabel](resultaten/dds.resultaten) te zetten, er is gebruik gemaakt van [dit script](scripts/DESeq2-analyse.R). Met de resultaten van de DESeq2 analyse zijn vervolgens drie andere analyses gedaan met [dit script](scripts/vulcano_plot,GO-analyse&KEGG_pathway.R). Daarna zijn drie aanvullende analyses uitgevoerd met behulp van de DESeq resultaten via [dit script](scripts/vulcano_plot,GO-analyse&KEGG_pathway.R):

- **Vulkaanplot:** Met [EnhancedVolcano v1.26.0](https://bioconductor.org/packages/release/bioc/html/EnhancedVolcano.html) is een vulkaanplot gegenereerd om significante genen te visualiseren.
- **GO-analyse:** Met behulp van [goseq v1.60.0](https://bioconductor.org/packages/release/bioc/html/goseq.html) is een Gene Ontology Enrichment Analysis uitgevoerd.
- **KEGG-analyse:** Voor de KEGG-Pathway analyse is besloten om hsa04660 te analyseren. Dit is gedaan met de [pathview](https://bioconductor.org/packages/release/bioc/html/pathview.html) library. De gekozen pathway is geselecteerd op basis van resultaten van de GO-analyse.

## 📈 Resultaten

Om te onderzoeken of dat Reumatoïde artritis invloed heeft op de expressie van genen is er een DESeq-analyse uitgevoerd de resultaten hiervan zijn beschikbaar in [deze tabel](resultaten/dds.resultaten). Hierin zijn alle genen met een p waarde en foldchange zichtbaar. 

Een bijbehorende [vulkaanplot](resultaten/vulcano_plot.png) toont de log2 van de foldchange tegenover de log10 van de p-waarde.  
- **Groene punten** = biologisch significante genen  
- **Rode punten** = biologisch- en statistisch significante genen  

| Regulatie          | Hoeveelheid genen|
| Neerwaarts         | 2487             |
| Opwaarts           | 2085             |

De [GO-analyse](resultaten/GO-analyse.csv) toont dat het proces *Adaptive immune response* (GO:0002250) de laagste p-waarde had [p = 0.004].

De KEGG-pathwayanalyse van [hsa04612](resultaten/hsa04612.png) laat zien dat veel genen in deze pathway **neerwaarts gereguleerd** zijn (groen gemarkeerd).


Clone the repository:

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
