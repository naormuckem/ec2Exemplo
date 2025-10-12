# Instância EC2 com Chave SSH usando Terraform

Este projeto cria uma instância EC2 na AWS usando o Terraform e gera um par de chaves SSH para acesso.

## Pré-requisitos

*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) instalado
*   [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) instalado

## Configurando as Credenciais da AWS

Para que o Terraform possa provisionar recursos na sua conta da AWS, você precisa configurar suas credenciais. Existem duas maneiras principais de fazer isso:

### 1. Variáveis de Ambiente

Você pode configurar suas credenciais como variáveis de ambiente no seu terminal. Esta é uma abordagem comum para ambientes de desenvolvimento e integração contínua.

```bash
export AWS_ACCESS_KEY_ID="SEU_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="SEU_SECRET_KEY"
export AWS_REGION="us-east-1" # ou sua região de preferência
```

**Importante:** As chaves de acesso acima são exemplos. Substitua pelos valores reais da sua conta da AWS.

### 2. Arquivo de Credenciais da AWS

O AWS CLI usa um arquivo de credenciais para armazenar suas chaves de acesso. Por padrão, este arquivo está localizado em `~/.aws/credentials` no Linux e macOS, e em `%USERPROFILE%\.aws\credentials` no Windows.

Você pode criar ou editar este arquivo com o seguinte formato:

```ini
[default]
aws_access_key_id = SEU_ACCESS_KEY
aws_secret_access_key = SEU_SECRET_KEY
```

Você também pode configurar a região padrão no arquivo `~/.aws/config`:

```ini
[default]
region = us-east-1
```

O Terraform usará automaticamente as credenciais do perfil `default`.

## Configurando o Pipeline de CI/CD com GitHub Actions

Este repositório contém um pipeline de CI/CD configurado com GitHub Actions. O pipeline irá automaticamente provisionar a infraestrutura na AWS sempre que um commit for enviado para a branch `main`.

Para que o pipeline funcione, você precisa configurar as credenciais da AWS como "secrets" no seu repositório do GitHub. Isso garante que suas chaves de acesso não fiquem expostas no código.

### Criando os Secrets no GitHub

1.  Navegue até a página principal do seu repositório no GitHub.
2.  Clique na aba **Settings** (Configurações).
3.  Na barra lateral esquerda, clique em **Secrets and variables** e depois em **Actions**.
4.  Clique no botão **New repository secret**.
5.  Crie os seguintes secrets:
    *   **`AWS_ACCESS_KEY_ID`**: Cole a sua "Access Key ID" da AWS neste campo.
    *   **`AWS_SECRET_ACCESS_KEY`**: Cole a sua "Secret Access Key" da AWS neste campo.

Com os secrets configurados, o pipeline de CI/CD terá as permissões necessárias para executar o Terraform na sua conta da AWS.

## Instruções

1.  **Clone o repositório:**
    ```bash
    git clone <url-do-repositorio>
    cd <nome-do-repositorio>
    ```

2.  **Inicialize o Terraform:**
    ```bash
    terraform init
    ```

3.  **Aplique a configuração do Terraform:**
    ```bash
    terraform apply
    ```
    O Terraform mostrará um plano dos recursos a serem criados. Digite `yes` para confirmar. Isso também irá gerar um novo arquivo de chave privada SSH chamado `terraform-key.pem` no diretório do projeto.

4.  **Conecte-se à instância EC2:**
    Após a conclusão do `apply`, o Terraform exibirá o endereço IP público da instância EC2. Você pode então se conectar a ela usando SSH:

    ```bash
    chmod 400 terraform-key.pem
    ssh -i terraform-key.pem ubuntu@<endereco-ip-publico>
    ```

    **Nota:** O arquivo `terraform-key.pem` é adicionado automaticamente ao `.gitignore` para evitar que seja enviado para o repositório.

## Como usar sua própria chave SSH

Se você preferir usar seu próprio par de chaves SSH existente, pode modificar o arquivo `main.tf`.

1.  **Gere um novo par de chaves SSH (se ainda não tiver um):**
    ```bash
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/minha-chave
    ```
    Isso criará os arquivos `minha-chave` e `minha-chave.pub` no seu diretório `~/.ssh`.

2.  **Modifique o `main.tf`:**
    Comente ou remova os recursos `tls_private_key` e `local_file`.

    ```terraform
    /*
    resource "tls_private_key" "ssh" {
      algorithm = "RSA"
      rsa_bits  = 4096
    }

    resource "local_file" "private_key" {
      content  = tls_private_key.ssh.private_key_pem
      filename = "${path.module}/terraform-key.pem"
      file_permission = "0400"
    }
    */
    ```

3.  **Atualize o recurso `aws_key_pair`:**
    Modifique o recurso `aws_key_pair` para usar o seu arquivo de chave pública.

    ```terraform
    resource "aws_key_pair" "deployer" {
      key_name   = "minha-chave" // ou qualquer nome que preferir
      public_key = file("~/.ssh/minha-chave.pub")
    }
    ```

4.  **Aplique as alterações:**
    ```bash
    terraform apply
    ```

## Limpeza

Para destruir os recursos criados pelo Terraform, execute:

```bash
terraform destroy
```
