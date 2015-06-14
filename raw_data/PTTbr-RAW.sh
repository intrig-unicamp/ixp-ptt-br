#!/bin/sh
# ============================================================================
# Information & Networking Technologies Research and Innovation Group (INTRIG)
# School of Electrical and Computer Engineering (FEEC)
# University of Campinas (UNICAMP)
# ============================================================================
# 1. Samuel Henrique Bucke Brito                   shbbrito@dca.fee.unicamp.br
# 2. Mateus Augusto Silva Santos                    msantos@dca.fee.unicamp.br
# 3. Ramon dos Reis Fontes                          ramonrf@dca.fee.unicamp.br
# 4. Danny Alex Lachos Perez                       dlachosp@dca.fee.unicamp.br
# 5. Hirley Dayan Silva                              hirley@dca.fee.unicamp.br
# 6. Christian Esteve Rothenberg                   chesteve@dca.fee.unicamp.br
# ============================================================================

all_ixp="bel ba cas ce cgb cpv cxj df gyn laj lda mao mg mgf nat pe pr rj rs sc sca sjc sjp sp vix"
pub_ixp="bel ce cpv df gyn lda mg pe pr rj rs sjc sp vix"
dbg_ixp="bel"

for code in ${pub_ixp}; do
  (echo "term l 0"; sleep 1; echo "show ip bgp"               ; sleep 7m; echo "exit";) | telnet lg.${code}.ptt.br | tee lg.${code}.ptt.br-BGP-IPv4.txt
  (echo "term l 0"; sleep 1; echo "show ipv6 bgp"             ; sleep 5m; echo "exit";) | telnet lg.${code}.ptt.br | tee lg.${code}.ptt.br-BGP-IPv6.txt
  (echo "term l 0"; sleep 1; echo "show ip bgp paths"         ; sleep 2m; echo "exit";) | telnet lg.${code}.ptt.br | tee lg.${code}.ptt.br-BGP-Paths.txt
  (echo "term l 0"; sleep 1; echo "show ip bgp community-info"; sleep 1m; echo "exit";) | telnet lg.${code}.ptt.br | tee lg.${code}.ptt.br-BGP-Community.txt
done
