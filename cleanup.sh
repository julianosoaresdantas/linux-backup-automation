#!/bin/bash
echo "Limpando ambiente de laboratório..."
sudo docker-compose down
sudo rm -rf logs/*.log
echo "Ambiente resetado. Pronto para novo teste."
