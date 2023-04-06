# Projeções Epidemiológicas - COVID-19

<hr>

<p align="center">
   <img src="http://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=RED&style=for-the-badge"/>
</p>

## Tópicos

- [Descrição do projeto](#descrição-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Começando](#começando)
- [Execução dos scripts](#execução-dos-scripts)
- [Construção](#construção)
- [Desenvolvedores](#desenvolvedores)

## Descrição do projeto

<p align="justify">
A conjuntura do Pará, segundo maior estado da federação, apresenta diversas complexidades características do contexto amazônico que podem potencializar os impactos de diversas doenças. Neste contexto, é relevante a criação de modelos capazes de identificar padrões baseado em dados observados com o intuito de realizar projeções futuras. Este projeto pretende produzir um framework capaz de gerar projeções sobre o comportamento de epidemias que afetam o estado do Pará, através de abordagens práticas, matematicamente competentes e computacionalmente eficientes. Os artefatos produzidos podem ser úteis para a tomada de decisão de gestores públicos, auxiliando na avaliação de impacto das intervenções, realocação de recursos hospitalares e otimização das estratégias de controle nas diversas regiões do Pará. <br> Essa base de dados é parte do projeto de bolsa cientifica "Projeções de Dados Epidemiológicos no Estado do Pará por meio de Inteligência Computacional e Modelagem Matemática", registrado pela Universidade Federal Rural da Amazônia, com bolsa da CNPq.

</p>

## Pré-requisitos

- Acesso ao <a href="https://colab.research.google.com/">Google Colab.</a>
- Conhecimento da linguagem de programação <a href="https://www.python.org/">Python</a>

- Conhecimento básico das bibliotecas:
  - <a href="https://matplotlib.org/">Matplotlib</a>
  - <a href="https://www.tensorflow.org/">TensorFlow</a>
  - <a href="https://unit8co.github.io/darts/">Darts</a>
  - <a href="https://numpy.org/">NumPy</a>
  - <a href="https://pandas.pydata.org/">Pandas</a>

## Começando

<p align="justify">
Para começar de forma local, faça um clone do repositório em sua máquina. <br>
Abra o terminal de comando ou o <a href="https://git-scm.com/">Git Bash</a> na sua máquina e, na pasta desejada, digite o seguinte código:
    <pre><code class="html"> git clone https://github.com/NPCA-TEAM/COVID-19.git</code></pre>
</p>

<p align="justify">
Se desejar, basta criar um fork do repositório seguindo normalmente os passos padrões.</p>

## Execução dos Scripts

<p align="justify">
Para visualizarmos todas as projeções, devemos passar por algumas etapas antes.
A seguir, será exposto a sequência de scripts que devera ser seguido para tratamento, treinamento e projeções corretas dos dados.
Temos os seguintes scrips: Coleta, Integração, Treino, Predição, Avaliação, Utilização, Suavização, Ajuste e Análise dos dados. Ou seja, temos aproximadamente doze scrips, onde em treinamento e predição temos scripts de casos e óbitos. A sequência é:

1. Coletar Dados
   Onde é coletado a média móvel dos dados de casos diagnosticados e óbitos confirmados.
   <br>
2. Integrar Dados
   Onde é criado dataframes com as médias móveis para cada situação:

   - Média Móvel Atual
   - Média Móvel de 7 dias
   - Média Móvel de 14 dias.
     <br>

3. Investidar Dados
   Onde e feito toda uma investigação em cima dos dados obtidos dos outros scripts, como:

   - Tratamento dos dados: Substituição de valores negativos ou iguais à 0 por valores que não irão comprometer a análise;
   - Estatistica: feito cálculo das médias, minimas, máximas e pesvio padrão;
   - Correlação Pearson: Feito correlaçao entre as colunas da tabela do dataset;
   - Modelos ingênuos: Utilizado os modelos NaiveSeasonal, NaiveDrift, NaiveMean e NaiveEnsemble;
   - Métrica de erro: utilizado as métricas mape e rmse.
     <br>

4. Treino (Casos e Óbitos)

   Dados treinados com os modelos NBEATS, TCN, Transformer, TFT e NHITS.
   \*Obs: Recomenda-se rodar primeiro o script de casos e depois óbitos, apesar da sequência não infuencias no restante dos scripts.
   <br>

5. Predição (Casos e Óbitos)

   Nos scripts de predição, os dados passam por um tratamento onde são selecionadas as variáveis e covariáveis para as projeções com base nos modelos treinados anteriormente. As predições ocorrem sobre os dados de treino e validação.
   \*Obs: Recomenda-se rodar primeiro o script de casos e depois óbitos, apesar da sequência não infuencias no restante dos scripts.
   <br>

6. Avaliação
   Script onde é realizado uma avalização nos dados do script de predição, onde ao final dele é gerado uma tabela de erro.
   <br>

7. Utilização do Modelo
   Este script utiliza as informações exportadas do melhor modelo treinado e realiza as projeções de acordo com eles, e com base no resultado das projeções, ele importa os gráficos gerados para uma pasta definida na anteriormente.
   <br>

8. Suavização e Ajuste da Projeção
   Este script está em .R, onde foi aplicado o medelo ARIMA sobre os resíduos gerados no script _Avaliação_.
   <br>

9. Ajuste da Projeção Pós-Uso do Modelo
   Script onde é realizado um ajuste nos dados após a utilização do modelo.
   <br>

10. Análise
    Script onde é realizado uma análise nos dados de casos e óbitos.
    <br>

11. Projeção Pós-Uso Modelo em Gráfico Único
    Este script é opcional, onde gera as projeções após o uso do modelo em gráficos únicos.
    <br>

</p>

## Construção

Aqui estão algumas das ferramentas que foram utilizadas para a construção desse projeto:

- <a href="https://matplotlib.org/">Matplotlib</a> - Biblioteca para a criação de estática, animada, e visualizações interativas em Python. Matplotlib torna as coisas fáceis coisas fáceis e difíceis possíveis.
- <a href="https://www.tensorflow.org/">TensorFlow</a> - Plataforma completa de código aberto para machine learning
- <a href="https://unit8co.github.io/darts/">Darts</a> - Biblioteca para previsão amigável e detecção de anomalias em séries temporais. Possui também uma variedade de modelos, de clássicos como ARIMA a redes neurais profundas
- <a href="https://pandas.pydata.org/">Pandas</a> - Ferramenta de análise e manipulação de dados de código aberto rápida, poderosa, flexível e fácil de usar.
- <a href="https://numpy.org/">NumPy</a> - Biblioteca que fornece um objeto de matriz multidimensional, vários derivados objetos e uma variedade de rotinas para operações rápidas em matrizes, incluindo manipulação matemática, lógica e de formas, classificação, seleção, E/S, transformadas discretas de Fourier, álgebra linear básica, operações estatísticas básicas, simulação aleatória e muito mais.

## Desenvolvedores

|           [<img src="https://paragominas.ufra.edu.br/images/CorpoDocente/gilberto.jpeg" width=115><br><sub>Dr. Gilberto Nerino</sub>](http://lattes.cnpq.br/8391942175575646)            |      [<img src="https://wwws.cnpq.br/cvlattesweb/pkg_util_img.show_foto?v_cod=K9780676Z0" width=115><br><sub>Alícia B. Mendes</sub>](https://lattes.cnpq.br/4828771292316532)      | [<img src="http://servicosweb.cnpq.br/wspessoa/servletrecuperafoto?tipo=1&id=K2408793D1" width=115><br><sub>Joaquim Costa</sub>](http://lattes.cnpq.br/0418295439393273) |              [<img src="https://avatars.githubusercontent.com/u/85235525?v=4" width=115><br><sub>Mikeias Oliveira</sub>](http://lattes.cnpq.br/9470698401889614)               |       [<img src="http://servicosweb.cnpq.br/wspessoa/servletrecuperafoto?tipo=1&id=K2161688T6" width=115><br><sub>Paulo Victor</sub>](http://lattes.cnpq.br/7930746516350512)       |     [<img src="http://servicosweb.cnpq.br/wspessoa/servletrecuperafoto?tipo=1&id=K9472509J4" width=115><br><sub>Vitor Nunes</sub>](http://lattes.cnpq.br/4531077583660245)      |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| <a href="https://github.com/NPCA-TEAM/COVID-19" target="_blank"><img height="20em" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></a> | <a href="https://github.com/aliciamendes" target="_blank"><img height="20em" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></a> |                                                                                                                                                                          | <a href="https://github.com/xpcosmos" target="_blank"><img height="20em" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></a> | <a href="https://github.com/VictorCunhali" target="_blank"><img height="20em" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></a> | <a href="https://github.com/iWizardXV" target="_blank"><img height="20em" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></a> |
