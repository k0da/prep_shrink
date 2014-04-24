prep_shrink
===========

YaST hook to srhink POWER's PReP partition to 8M

After partitioning is done. Hook is looking for partitions with either 0x41(msdos) or 0x108(gpt) partition ID

If founded partition is bigger than 8192k, hook resizes a partition to 8M
