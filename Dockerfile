FROM ubuntu:latest

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    git \
    gnupg \
    lsb-release

# Créer un utilisateur non-root et changer vers cet utilisateur
RUN useradd -m runneruser && \
    mkdir /actions-runner && \
    chown runneruser:runneruser /actions-runner

USER runneruser
WORKDIR /actions-runner

# Télécharger et installer le runner
RUN curl -o actions-runner-linux-x64-2.313.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.313.0/actions-runner-linux-x64-2.313.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.313.0.tar.gz && \
    rm ./actions-runner-linux-x64-2.313.0.tar.gz

# La configuration ne peut pas être réalisée ici car le token a une durée de vie limitée
# et ne doit pas être inclus dans une image Docker pour des raisons de sécurité.
# Utilisez un script d'entrée pour configurer le runner au démarrage du conteneur.

COPY entrypoint.sh /entrypoint.sh
RUN sudo chown runneruser:runneruser /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run.sh"]