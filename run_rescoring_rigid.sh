#!/bin/bash
cd /app/DXGB
mkdir -p /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina

# Entra na pasta onde o programa DXGB está instalado no Docker
cd /app/DXGB

for f in /app/Teste_rescoring/Arquivos_rescoring_rigid/*_ligand.sdf; do
    id=$(basename "$f" _ligand.sdf)
    
    echo "Avaliando a molécula: $id"
    
    # 1. Roda a Inteligência Artificial
    python run_DXGB.py --runfeatures --datadir /app/Teste_rescoring/Arquivos_rescoring_rigid --pdbid "$id" --average --runrf
    
    # 2. Renomeia e move os arquivos genéricos (score, Input, SASA, etc.)
    for file in score.csv Input.csv dE_RMSD.csv SASA.csv Vina58.csv Num_Ions.csv Ion_infor.dat get_RF20.R; do
        mv "/app/Teste_rescoring/Arquivos_rescoring_rigid/$file" "/app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina/${id}_${file}" 2>/dev/null
    done
    
    # 3. Move os arquivos temporários estruturais que já têm o nome da molécula
    mv /app/Teste_rescoring/Arquivos_rescoring_rigid/${id}_*confs.sdf /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina/ 2>/dev/null
    mv /app/Teste_rescoring/Arquivos_rescoring_rigid/${id}_*min* /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina/ 2>/dev/null
    mv /app/Teste_rescoring/Arquivos_rescoring_rigid/${id}_*rename.pdb /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina/ 2>/dev/null
    mv /app/Teste_rescoring/Arquivos_rescoring_rigid/${id}_*.pdbqt /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina/ 2>/dev/null
    mv /app/Teste_rescoring/Arquivos_rescoring_rigid/${id}_*.xyzr /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina/ 2>/dev/null
done

echo "Análise concluída! Todos os resultados estão na pasta resultados_deltavina."

#4. Limpeza dos dados

# Entrar na pasta de resultados
cd /app/Teste_rescoring/Arquivos_rescoring_rigid/resultados_deltavina

# Manter apenas as planilhas principais e apagar todo o resto do lixo digital
rm -f *SASA* *Vina58* *Num_Ions* *Ion_infor* *get_RF20* *dE_RMSD* *.sdf *.pdb *.pdbqt *.xyzr

#Criar tabela com todos os resultados e nomear suas colunas
echo "pdb,vina,XGB,RF20" > tabela_rescoring_deltavina.csv

#Seleciona o score de todos os arquivos gerados e anexa na tabela
tail -q -n +2 *_score.csv >> tabela_rescoring_deltavina.csv