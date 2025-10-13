# Exercício Terraform RDS

## Objetivo

O objetivo deste exercício é adicionar uma instância RDS com PostgreSQL à configuração Terraform existente.

## Instruções

1.  Faça um fork deste repositório.
2.  Crie uma nova branch chamada `add-rds-instance`.
3.  Na nova branch, crie um novo arquivo chamado `rds.tf`.
4.  No arquivo `rds.tf`, adicione o código Terraform necessário para provisionar uma instância RDS com os seguintes requisitos:
    *   **Classe da instância:** `db.t2.micro`
    *   **Engine:** `postgres`
    *   **Nome do banco de dados:** `studentdb`
    *   **Nome de usuário:** `student`
    *   **Senha:** Crie um novo secret em seu repositório chamado `DB_PASSWORD` e use-o em sua configuração.
    *   **Acessível publicamente:** `true`
5.  Crie um Pull Request para a branch `main` do repositório original.
6. Coloque no titulo da sua Pull Request o seu RA e Nome Completo.


## Validação

Seu Pull Request será validado automaticamente por um workflow do GitHub Actions. O workflow verificará se o seu código Terraform é válido e se ele pode gerar um plano.