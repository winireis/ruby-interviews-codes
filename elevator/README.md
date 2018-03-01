# Introdução
A Acme Inc foi contratada para desenvolver um sistema de otimização de elevadores. O funcionamento do elevador é baseado em um console no qual os usuários do elevador digitam o andar que querem ir e o elevador responde qual dos elevadores pegar. O objetivo do nosso sistema é reduzir o tempo médio que as pessoas esperam pelo elevador e o tempo médio de chegada no andar para cada pessoa.

# Especificações
O elevador anda 0.5 andar por segundo quando em movimento.

As portas abrem e fecham em um intervalo de 20 segundos (tempo que o elevador fica parado em cada andar).

Cada elevador comporta um máximo de 8 pessoas.

O andar 1 é o térreo e onde todos os elevadores começam e por onde todas as pessoas entram.

# Teste
A E-Corp é um cliente parceiro que se ofereceu para testar o sistema. O prédio da E-Corp possui 4 elevadores como os descritos acima e 25 andares. A Acme Inc contratou 1000 pessoas para ajudar nos testes. A ordem de chegada e o tempo de chegada das 1000 pessoas está no arquivo CSV anexo.

# Problema
Você precisa prover o algoritmo que faz a otimização do elevador, bem como um teste (no mínimo) que prove que o algoritmo funciona para o conjunto de pessoas no arquivo anexo. Funcionar, nesse caso quer dizer que as pessoas chegam no andar que desejavam. Você também precisa calcular onde está cada elevador.

Além disso, o seu programa precisa informar o tempo médio de espera de cada usuário, o tempo médio de chegada no andar para cada pessoa e o tempo médio de espera total de cada pessoa (tempo na fila + tempo de saída do elevador).

O objetivo do algoritmo é reduzir o tempo médio de espera total de cada pessoa.

# Solução
Recomendamos redirecionar a saída da execução da solução do problema para um arquivo .txt. As três primeiras linhas indicam as médias do tempo de espera, tempo dentro do elevador, tempo total para chegar oo andar de destino. As demais linhas representam o estado final da simulação; Exibindo cada pessoa presente em um determinado andar e seu respectivo tempo de espera, o tempo dentro do elevador e o tempo total.

Para executar a solução **ruby simulator.rb > answer.txt**.
