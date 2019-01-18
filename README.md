> Work of October of 2017.

> [André Felipe B. Menezes](https://github.com/AndrMenezes) and [Wesley O. Furriel](https://github.com/WOLFurriell)

# Análise das séries temporais de estações GPS presentes na região Norte e Leste do Brasil

Estrutura de dados em que as observações são feitas sequencialmente ao longo do tempo
são classificados como séries temporais. A característica mais importante de uma série temporal
é que as observações vizinhas são dependentes, sendo o interesse analisar e modelar esta dependência.
Dados no formato de séries temporais surgem nos mais diversos campos do conhecimento, como por exemplo
em Economia, Medicina, Marketing, Demografia, Epidemiologia, Heterologia, entre outros.

O presente trabalha visa empregar os modelos autorregressivos integrados de médias móveis introduzidos por
Box e Jenkins (1976) para analisar as séries temporais de coordenadas provenientes do processamento dos dados coletados pelos 
receptores GNSS (Global Navigation Satellite System), em especial, o GPS (Global Positioning System), ao longo do tempo. 
Os dados que serão analisados referem-se a média semanais durante o período de 2008 a 2017. As componentes \emph{EAST} e 
\emph{NORTH} das estações localizadas nas regiões Norte e Amazônica do Brasil, 
sendo suas siglas NAUS, POVE, ROJI, MAPA, SALU, BRFT, RECF e SAVO foram consideradas. 
Portanto, 16 séries temporais foram analisadas no presente trabalho.

Além desta introdução o presente trabalho esta organizado da seguinte forma. 
Na Seção 2, discutimos o modelo autorregressivo integrado de médias móveis e apresentamos 
o esquema adotado para modelagem das 16 séries. 
Os resultados da modelagem para cada série temporal é apresentado e discutido em detalhes na
Seção 3. E por fim, têm-se algumas considerações finais.

***
> [Report](https://github.com/AndrMenezes/ts2017/raw/master/final_work/report.pdf)

> [Presentation](https://github.com/AndrMenezes/ts2017/raw/master/final_work/presentation.pdf)

> [R script](https://github.com/AndrMenezes/ts2017/raw/master/final_work/report_rmarkdown.pdf)
***
