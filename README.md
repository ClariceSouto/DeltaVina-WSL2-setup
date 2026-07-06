# DeltaVina-WSL2-setup
Este repositório centraliza as modificações necessárias para rodar o **DeltaVinaRF20** e o **DeltaVinaXGB** no Windows Subsystem for Linux (WSL2). Disponível no "https://github.com/chengwang88/vina4dv.git", seu código original possui dependências antigas e trechos que causavam erros de compilação devido a atualizações realizadas com os anos. As correções foram realizadas via Docker e scripts em Bash.

<img width="300" height="408" alt="Diagrama_deltavina" src="https://github.com/user-attachments/assets/157ef17b-b9d7-467d-a286-ec5b350915bd" />

-----

Especificações do ambiente testado:
**Sistema Operacional:** Windows 11 + WSL2 (V.2.3.26.0)
**Versão do R:** 4.5.2
**MGLTools:** v1.5.6

--------

# 1. Ajuste de Memória do WSL2
Para evitar travamentos por falta de memória durante a construção da imagem Docker, abra o **PowerShell** no seu Windows e execute os comandos abaixo para configurar os limites de recursos:

```
powershell
echo "[wsl2]" > $HOME\.wslconfig
echo "memory=4GB" >> $HOME\.wslconfig
echo "swap=16GB" >> $HOME\.wslconfig
wsl --shutdown
```

# 2. Clonar o repositório e criar o container
No terminal do seu WSL2, clone este repositório e compile a imagem Docker. Todas as correções no código C++ e de pacotes (como a substituição do moleculekit quebrado) já serão aplicadas automaticamente durante o build:

```
git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
cd seu-repositorio
sudo docker build -t deltavinaxgb .
```

# 3. Organizar seus arquivos de entrada (ou baixar os disponíveis em ArquivosTeste)
Crie uma pasta local e adicione os arquivos das suas moléculas seguindo rigorosamente a padronização exigida pelo DeltaVina:

```
mol_<ID>_ligand.pdb e mol_<ID>_ligand.sdf   
mol_<ID>_protein.pdb (Proteína sem moléculas de água)   
mol_<ID>_protein_all.pdb (Proteína com moléculas de água/solvente | proteínas sem molécula de água, caso você esteja trabalhando com ela apenas sem água/solvente)  
```

# 4. Executar o script Automatizado
Rode o container mapeando a sua pasta de dados (substitua o caminho do exemplo pelo seu caminho real do Windows):

```
sudo docker run -it -v /mnt/c/Caminho/Para/Sua/Pasta:/app/dados deltavinaxgb:latest /bin/bash
```
Dentro do container, ative o ambiente virtual e chame o script de automação incluso neste repositório:

```
source activate DXGB
bash /app/run_rescoring.sh
```

----

Resultado esperado: todas as moléculas serão processadas em lote, os arquivos temporários são removidos e os scores finais ficam disponíveis em tabelas.
