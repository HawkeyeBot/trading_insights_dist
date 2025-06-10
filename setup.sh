#!/bin/bash

PS3='Select the desired action:'
options=("Install" "Update" "Uninstall" "Quit")
select opt in "${options[@]}"
do
    case $opt in
      "Quit")
          break
          ;;
    esac

    sudo apt-get update
    sudo apt-get install python3-pip -y
    pip3 install --break-system-packages -r ansible/requirements.txt
    if [ ! -f ~/.ssh/id_rsa.pub ]; then
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    fi

    rm ~/.ansible.cfg

    echo "[defaults]
    localhost_warning=False

    [inventory]
    inventory_unparsed_warning=False" | sudo tee -a ~/.ansible.cfg

    cd ansible
    case $opt in
        "Install")
            ansible-playbook multi-scraper.yaml

            break
            ;;
        "Update")
            ansible-playbook remove-multi-scraper.yaml
            ansible-playbook multi-scraper.yaml

            break
            ;;
        "Uninstall")
            ansible-playbook remove-multi-scraper.yaml
            ansible-playbook remove-postgres.yaml

            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
    cd ../
done