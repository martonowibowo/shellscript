#!/bin/bash
useradd acomprod
echo 'acomprod ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
su acomprod -c 'ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""'
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+QHvFtfoWhg/3n97CagmpOXVdOyrgfM5sA4t8m+M7dmcWVgpYu3Z6a4xahB5+Ybk1y/W9kK+U+KAlPW6ieEt724koPWvGfO+0Zq1yiyfcIeTr85ItyQXhaTuyS4TgAWj0JQ5+NWU5sfz1m037Ap93FiLBNFiI7Pb5FrGlMuWSrzpfR34xX092rrAKGlYmIV0/cAOZN1IP7YC9XEHNvNrgUDsT5sQYtjfttFTLO+gp0vXFBzbvSVxaxYvgHEkEZ5gnavQjPiVKzZK1txEqJ8/6JZ2uzZl9RoNTyxFOyikpkoM3Za3DfsgTGl4YRl9l14WSPyPn8zd5QEO2+fiv4ZAJ martonowibowo@martono-devops" > /home/acomprod/.ssh/authorized_keys
chmod 600 /home/acomprod/.ssh/authorized_keys
