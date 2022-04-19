
**Matlab files are rate maps of cells used to generate correlation matrices for the cue-conflict and population vector correlations for the two shape and the two room experiments.  

1) cue_rotation.mat -- used for Fig. 3
--contains animal group for each location and mismatch angle
	--each struct contains information score (lininfo), p value for the information score (lininfop), number of spikes on track (nspksontracks), and metrix (linearized rate map) for each cell
	--each row is a cell
	--MIS is mismatch session
	--STD1 is standard session before a MIS session
	--STD2 is standard session after a MIS session

2) two_shape.mat -- used for Fig. 5
-- contains animal group for each location
	--each cell contains rate maps across the four recording sessions (each column is a session)
	--each row is a cell

3) two_room.mat -- used for Fig. 6
-- contains animal group for each location
	--each cell contains rate maps across the two recording rooms (each column is a room)
	--each row is a cell

**CSV files are the calculated correlation differences at each tetrode location for the cue-conflict, for the two-shape, and for the two-room for each animal group.  

1) Y_tetall, AU_tetall, AI_tetall -- used for Fig. 3
2) Y_shape, AU_shape, AI_shape -- used for Fig. 5
3) Y_room, AU_room, AI_room -- used for Fig. 6

--each file contains 5 columns
	--col_1) rat #
	--col_2) tetrode #
	--col_3) distance along the CA3 transverse axis (0 proximal end; 1 distal end)
	--col_4) speed of the rat
	--col_5) calculated difference value   