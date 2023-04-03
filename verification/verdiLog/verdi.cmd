debImport "-sv" "-f" "file.lst"
debLoadSimResult /home/ICer/ic_prjs/open_mips/verification/tb.fsdb
wvCreateWindow
verdiWindowResize -win $_Verdi_1 "776" "204" "900" "700"
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_inst_rom" -win $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips" -win $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_inst_rom" -win $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem" -win \
           $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mips_div" -win \
           $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_hilo_reg" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_hilo_reg" \
           -delim "."
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_hilo_reg" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "hi_o" -line 19 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "lo_o" -line 20 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "we" -line 15 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "hi_i" -line 16 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "lo_i" -line 17 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSelectGroup -win $_nWave2 {G2}
wvSetPosition -win $_nWave2 {("G2" 0)}
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_if_id" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_if_id" \
           -delim "."
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_if_id" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "id_inst" -line 11 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "id_rom_ce" -line 12 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "id_pc" -line 10 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "id_rom_ce" -line 12 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectGroup -win $_nWave2 {G3}
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_id" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_id" -delim \
           "."
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_id" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 44 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "pc_i" -line 15 -pos 1 -win $_nTrace1
srcSelect -signal "rom_ce_dff_i" -line 17 -pos 1 -win $_nTrace1
srcSelect -signal "inst_i" -line 16 -pos 1 -win $_nTrace1
srcSelect -toggle -signal "rom_ce_dff_i" -line 17 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G2" 2 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 3)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSelectSignal -win $_nWave2 {( "G2" 2 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetOptions -win $_nWave2 -hierName on
wvSetOptions -win $_nWave2 -hierName off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "aluop_o" -line 39 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wd_o" -line 36 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "wreg_o" -line 37 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSetPosition -win $_nWave2 {("G3" 1)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G3" 1)}
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 1 )} 
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
srcDeselectAll -win $_nTrace1
srcSelect -signal "aluop_o" -line 39 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "alusel_o" -line 40 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "reg1_o" -line 41 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "reg2_o" -line 42 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 44 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 44 -pos 1 -win $_nTrace1
srcAction -pos 43 5 4 -win $_nTrace1 -name "stallreq" -ctrlKey off
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetPosition -win $_nWave2 {("G3" 7)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 7)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 605 -pos 1 -win $_nTrace1
srcAction -pos 604 1 4 -win $_nTrace1 -name "stallreq" -ctrlKey off
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G3" 8 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G3" 7)}
wvSelectSignal -win $_nWave2 {( "G3" 7 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G3" 6)}
srcSearchString "stallreq" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {605 605 2 3 1 1}
srcSearchString "stallreq" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {602 602 1 2 26 1}
srcSearchString "stallreq" -win $_nTrace1 -next -case
srcSearchString "stallreq" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 44 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 44 -pos 1 -win $_nTrace1
srcAction -pos 43 5 6 -win $_nTrace1 -name "stallreq" -ctrlKey off
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 6 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvZoom -win $_nWave2 137580.279856 404360.314908
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
wvSelectSignal -win $_nWave2 {( "G3" 4 )} 
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G3" 7 )} 
wvSelectSignal -win $_nWave2 {( "G3" 6 )} 
wvSelectSignal -win $_nWave2 {( "G3" 5 )} 
srcDeselectAll -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSetRadix -win $_nWave2 -format Bin
wvZoom -win $_nWave2 265118.871359 405734.405340
wvZoomOut -win $_nWave2
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetCursor -win $_nWave2 309487.850528 -snap {("G3" 1)}
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_id_ex" -win \
           $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem" -win \
           $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem_wb" -win \
           $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_ex" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_ex" -delim \
           "."
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_ex" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "aluop_i" -line 14 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G4" 1 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSetCursor -win $_nWave2 329965.840913 -snap {("G4" 1)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "reg2_i" -line 17 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "reg1_i" -line 16 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "reg2_i" -line 17 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 330307.140753 -snap {("G4" 1)}
wvSetMarker -win $_nWave2 -keepViewRange -name "DIV" 330000.000000 ID_GREEN5 \
           long_dashed
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "stallreq" -line 38 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "signed_div_o" -line 47 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_opdata1_o" -line 48 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_opdata2_o" -line 49 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_start_o" -line 50 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_opdata1_o" -line 48 -pos 1 -win $_nTrace1
srcAction -pos 47 15 9 -win $_nTrace1 -name "div_opdata1_o" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_ex.DIVIDE_OUPUT_PROC" \
           -win $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_ex" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "cnt_i" -line 41 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "cnt_o" -line 43 -pos 1 -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "G4" 9 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G4" 8)}
wvSelectSignal -win $_nWave2 {( "G4" 8 )} 
wvSetPosition -win $_nWave2 {("G4" 7)}
wvSetPosition -win $_nWave2 {("G4" 6)}
wvSetPosition -win $_nWave2 {("G4" 5)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G4" 5)}
wvSetPosition -win $_nWave2 {("G4" 6)}
wvSetPosition -win $_nWave2 {("G4" 8)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_valid_i" -line 46 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_result_i" -line 45 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetPosition -win $_nWave2 {("G5" 0)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "div_start_o" -line 50 -pos 1 -win $_nTrace1
srcSetScope "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.div_start_o" \
           -win $_nTrace1
srcSetScope "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.div_start_o" \
           -win $_nTrace1
srcSetScope \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mips_div.start_i" \
           -win $_nTrace1
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 19 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rst_n" -line 20 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "signed_div_i" -line 21 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "opdata1_i" -line 22 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "opdata2_i" -line 23 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "start_i" -line 24 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "annul_i" -line 25 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "result_o" -line 26 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "valid_o" -line 27 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvScrollDown -win $_nWave2 1
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G5" 8)}
wvSelectSignal -win $_nWave2 {( "G5" 8 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G5" 7)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 7
wvSelectGroup -win $_nWave2 {G4}
wvSelectGroup -win $_nWave2 {G3}
wvScrollUp -win $_nWave2 2
wvSelectGroup -win $_nWave2 {G2}
wvSelectGroup -win $_nWave2 {G1}
srcDeselectAll -win $_nTrace1
srcSelect -signal "state" -line 41 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "state" -line 41 -pos 1 -win $_nTrace1
srcAction -pos 40 8 2 -win $_nTrace1 -name "state" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "state_nxt" -line 156 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 197740.594660 -snap {("G5" 7)}
wvSelectSignal -win $_nWave2 {( "G5" 9 )} 
wvSelectSignal -win $_nWave2 {( "G5" 2 )} 
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem_wb" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem_wb" \
           -delim "."
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem_wb" -win \
           $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mem_wb" -win \
           $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mips_div" -win \
           $_nTrace1
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
debReload
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 1028251.092233 -snap {("G5" 3)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "DIV_FREE" -line 155 -pos 1 -win $_nTrace1
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mips_div" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mips_div" \
           -delim "."
srcHBSelect "openmips_min_scop_tb.u_openmips_min_scop.u_openmips.u_mips_div" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "valid_o" -line 28 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "result_o" -line 27 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G5" 9 )} 
wvSetCursor -win $_nWave2 1190105.430825 -snap {("G5" 1)}
wvSetCursor -win $_nWave2 1012138.895631 -snap {("G5" 10)}
wvSetCursor -win $_nWave2 331764.775485 -snap {("G5" 1)}
wvSetMarker -win $_nWave2 1010000.000000
wvSetCursor -win $_nWave2 369848.149272 -snap {("G5" 1)}
wvSignalReport -win $_nWave2 -add \
           "\{/openmips_min_scop_tb/u_openmips_min_scop/u_openmips/u_mips_div/state_nxt\[1:0\]\}"
wvSetCursor -win $_nWave2 366918.658981 -snap {("G5" 1)}
wvSignalReport -win $_nWave2 -add \
           "\{/openmips_min_scop_tb/u_openmips_min_scop/u_openmips/u_mips_div/state_nxt\[1:0\]\}"
wvSetMarker -win $_nWave2 390000.000000
wvSetMarker -win $_nWave2 1010000.000000
wvZoom -win $_nWave2 966731.796117 1073658.191748
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 318382.888350 1499583.404126
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 1014915.006274 -snap {("G5" 10)}
wvSetCursor -win $_nWave2 1702992.976630 -snap {("G5" 10)}
wvZoom -win $_nWave2 1599781.281076 2001160.097117
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G4}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G2}
debExit
