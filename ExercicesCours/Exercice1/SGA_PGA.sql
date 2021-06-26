#SGA
select * from v$sgastat;

/*POOL	NAME		BYTES		CON_ID
(null)	fixed_sga	8932744	0
(null)	buffer_cache	754974720	0
(null)	log_buffer	74952704	0
(null)	shared_io_pool	134217728	0*/

#PGA
select * from v$pgastat;

/*
aggregate PGA target parameter			0	bytes	0
aggregate PGA auto target			0	bytes	0
global memory bound			183756800	bytes	0
total PGA inuse					7911424	bytes	0
total PGA allocated			12401664	bytes	0
maximum PGA allocated			542478336	bytes	0
total freeable PGA memory			1179648	bytes	0
MGA allocated (under PGA)			0	bytes	0
maximum MGA allocated			        0	bytes	0
process count					2	(null)	0
max processes count				40	(null)	0
PGA memory freed back to OS		74355441664	bytes	0
total PGA used for auto workareas		0	bytes	0
maximum PGA used for auto workareas	55457792	bytes	0
total PGA used for manual workareas		0	bytes	0
maximum PGA used for manual workareas		1067008	bytes	0
over allocation count				0	(null)	0
bytes processed				207305112576	bytes	0
extra bytes read/written			0	bytes	0
cache hit percentage				100	percent	0
recompute count (total)				3536348	(null)	0*/

