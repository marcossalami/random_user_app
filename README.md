# random_user_app

📱 **Random User App**

Um aplicativo Flutter moderno que consome a [Random User API](https://randomuser.me/) para gerar, visualizar e persistir perfis de usuários. O projeto demonstra o uso de arquitetura limpa, gerenciamento de estado reativo e persistência de dados local.

---

## ✨ Funcionalidades

*   **Geração Automática:** Utiliza um `Ticker` para buscar novos usuários a cada 5 segundos automaticamente.
*   **Listagem Dinâmica:** Exibição de usuários em tempo real com animações fluidas.
*   **Detalhes do Usuário:** Tela rica em detalhes com efeito de desfoque (Blur) e animações Hero.
*   **Persistência de Dados:** Capacidade de salvar ("favoritar") usuários localmente para acesso offline.
*   **Gerenciamento:** Remoção de usuários salvos com gestos (Dismissible) e feedback visual.

## 🛠️ Tecnologias e Arquitetura

O projeto foi construído seguindo os princípios de **MVVM (Model-View-ViewModel)** e **Repository Pattern**, garantindo separação de responsabilidades e testabilidade.

*   **Linguagem:** Dart
*   **Framework:** Flutter
*   **Gerenciamento de Estado:** `Provider`
*   **Persistência Local:** `Hive` (NoSQL leve e rápido)
*   **Injeção de Dependência:** `GetIt`
*   **Serialização:** `json_serializable` & `json_annotation`
*   **Requisições HTTP:** `Dio` (ou `http`)

## 📂 Estrutura de Pastas

A estrutura do projeto é organizada por *features* (funcionalidades), facilitando a escalabilidade:

```
lib/
├── core/
│   └── di/              # Injeção de dependências (Service Locator)
├── features/
│   └── user/
│       ├── data/
│       │   └── models/  # Modelos de dados (UserModel, Hive Adapters)
│       ├── domain/
│       │   └── repositories/ # Interfaces dos repositórios
│       └── presentation/
│           ├── provider/     # Gerenciamento de estado (UserProvider)
│           ├── screens/      # Telas (UserScreen, Detail, Persisted)
│           └── widgets/      # Componentes reutilizáveis (InfoTile, Section)
└── main.dart            # Ponto de entrada e inicialização
```

## 🚀 Como Rodar

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/seu-usuario/random_user_app.git
    ```

2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Gere os arquivos de código (Hive/Json):**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Execute o app:**
    ```bash
    flutter run
    ```

