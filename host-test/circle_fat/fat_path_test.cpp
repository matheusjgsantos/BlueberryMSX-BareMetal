//
// fat_path_test.cpp
//
// Host regression test for the Circle FAT driver: create, write, close and
// re-open files inside an EXISTING subdirectory, and verify that the entry is
// actually stored in that directory (path-aware CreateEntry) and that the file
// handle keeps the whole path through FileClose (FS_TITLE_LEN).
//
// The test runs the real Circle FAT sources (lib/fs/fat/*.cpp) against a
// RAM-backed CDevice and stub Circle headers, so it can run on the host.
//
// Usage: fat_path_test <image> write|read
//
#include <circle/fs/fat/fatfs.h>
#include <circle/device.h>
#include <circle/types.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <string>
#include <vector>

extern "C" void diag_uart (char c)
{
	(void) c;
}

extern "C" void assertion_failed (const char *pExpr, const char *pFile, unsigned nLine)
{
	fprintf (stderr, "assertion failed: %s (%s:%u)\n", pExpr, pFile, nLine);
	abort ();
}

// ---------------------------------------------------------------- file data

static const unsigned NUM_DIR_FILES = 100;
static const unsigned DIR_FILE_SIZE = 700;
static const unsigned DEEP_FILE_SIZE = 1200;
static const unsigned ROOT_FILE_SIZE = 1000;

static unsigned char Pattern (unsigned nSeed, unsigned nIndex)
{
	return (unsigned char) ((nSeed * 37u + nIndex * 11u + (nIndex >> 8)) & 0xFF);
}

typedef struct
{
	char Name[64];
	unsigned nSeed;
	unsigned nSize;
} TTestFile;

static unsigned GetTestFiles (TTestFile *pFiles)
{
	unsigned n = 0;

	for (unsigned i = 0; i < NUM_DIR_FILES; i++)
	{
		snprintf (pFiles[n].Name, sizeof pFiles[n].Name, "capture/T%03u.BIN", i);
		pFiles[n].nSeed = i + 1;
		pFiles[n].nSize = DIR_FILE_SIZE;
		n++;
	}

	snprintf (pFiles[n].Name, sizeof pFiles[n].Name, "capture/NESTED/DEEP.TXT");
	pFiles[n].nSeed = 7;
	pFiles[n].nSize = DEEP_FILE_SIZE;
	n++;

	snprintf (pFiles[n].Name, sizeof pFiles[n].Name, "ROOT.BIN");
	pFiles[n].nSeed = 9;
	pFiles[n].nSize = ROOT_FILE_SIZE;
	n++;

	return n;
}

static void FillPattern (std::vector<unsigned char> &Buffer, unsigned nSeed, unsigned nSize)
{
	Buffer.resize (nSize);
	for (unsigned i = 0; i < nSize; i++)
	{
		Buffer[i] = Pattern (nSeed, i);
	}
}

// ------------------------------------------------------------------- ramdisk

class CRamDisk : public CDevice
{
public:
	explicit CRamDisk (std::vector<unsigned char> *pImage)
	:	m_pImage (pImage),
		m_nOffset (0)
	{
	}

	int Read (void *pBuffer, size_t nCount) override
	{
		if (m_nOffset + nCount > m_pImage->size ())
		{
			return -1;
		}

		memcpy (pBuffer, &(*m_pImage)[(size_t) m_nOffset], nCount);
		m_nOffset += nCount;

		return (int) nCount;
	}

	int Write (const void *pBuffer, size_t nCount) override
	{
		if (m_nOffset + nCount > m_pImage->size ())
		{
			return -1;
		}

		memcpy (&(*m_pImage)[(size_t) m_nOffset], pBuffer, nCount);
		m_nOffset += nCount;

		return (int) nCount;
	}

	u64 Seek (u64 ullOffset) override
	{
		if (ullOffset > m_pImage->size ())
		{
			return (u64) -1;
		}

		m_nOffset = ullOffset;

		return ullOffset;
	}

	u64 GetSize (void) const override
	{
		return m_pImage->size ();
	}

private:
	std::vector<unsigned char> *m_pImage;
	u64 m_nOffset;
};

// --------------------------------------------------------------------- main

static int LoadImage (const char *pPath, std::vector<unsigned char> &Image)
{
	FILE *pFile = fopen (pPath, "rb");
	if (pFile == 0)
	{
		fprintf (stderr, "cannot open image %s\n", pPath);
		return 0;
	}

	fseek (pFile, 0, SEEK_END);
	long nSize = ftell (pFile);
	fseek (pFile, 0, SEEK_SET);

	if (nSize <= 0)
	{
		fclose (pFile);
		return 0;
	}

	Image.resize ((size_t) nSize);
	if (fread (&Image[0], 1, (size_t) nSize, pFile) != (size_t) nSize)
	{
		fclose (pFile);
		return 0;
	}

	fclose (pFile);

	return 1;
}

static int SaveImage (const char *pPath, const std::vector<unsigned char> &Image)
{
	FILE *pFile = fopen (pPath, "wb");
	if (pFile == 0)
	{
		return 0;
	}

	size_t nWritten = fwrite (&Image[0], 1, Image.size (), pFile);
	fclose (pFile);

	return nWritten == Image.size ();
}

int main (int argc, char **argv)
{
	if (argc != 3 || (strcmp (argv[2], "write") != 0 && strcmp (argv[2], "read") != 0))
	{
		fprintf (stderr, "usage: %s <image> write|read\n", argv[0]);
		return 2;
	}

	const char *pImagePath = argv[1];
	bool bWrite = strcmp (argv[2], "write") == 0;

	std::vector<unsigned char> Image;
	if (!LoadImage (pImagePath, Image))
	{
		return 1;
	}

	CRamDisk Disk (&Image);
	CFATFileSystem FileSystem;

	if (!FileSystem.Mount (&Disk))
	{
		fprintf (stderr, "FAIL: cannot mount the FAT image\n");
		return 1;
	}

	TTestFile Files[128];
	unsigned nFiles = GetTestFiles (Files);

	unsigned nErrors = 0;

	if (bWrite)
	{
		std::vector<unsigned char> Buffer;

		for (unsigned i = 0; i < nFiles; i++)
		{
			FillPattern (Buffer, Files[i].nSeed, Files[i].nSize);

			unsigned hFile = FileSystem.FileCreate (Files[i].Name);
			if (hFile == 0)
			{
				printf ("FAIL: FileCreate(%s)\n", Files[i].Name);
				nErrors++;
				continue;
			}

			if (FileSystem.FileWrite (hFile, &Buffer[0], (unsigned) Buffer.size ())
			    != Buffer.size ())
			{
				printf ("FAIL: FileWrite(%s)\n", Files[i].Name);
				nErrors++;
			}

			if (!FileSystem.FileClose (hFile))
			{
				printf ("FAIL: FileClose(%s)\n", Files[i].Name);
				nErrors++;
			}
		}

		FileSystem.Synchronize ();

		if (!SaveImage (pImagePath, Image))
		{
			printf ("FAIL: cannot write back the image\n");
			nErrors++;
		}
	}
	else
	{
		for (unsigned i = 0; i < nFiles; i++)
		{
			unsigned hFile = FileSystem.FileOpen (Files[i].Name);
			if (hFile == 0)
			{
				printf ("FAIL: FileOpen(%s) after remount\n", Files[i].Name);
				nErrors++;
				continue;
			}

			std::vector<unsigned char> Buffer (Files[i].nSize, 0);
			unsigned nRead = FileSystem.FileRead (hFile, &Buffer[0],
							      (unsigned) Buffer.size ());
			FileSystem.FileClose (hFile);

			if (nRead != Buffer.size ())
			{
				printf ("FAIL: FileRead(%s): %u of %u bytes\n",
					Files[i].Name, nRead, Files[i].nSize);
				nErrors++;
				continue;
			}

			for (unsigned k = 0; k < Files[i].nSize; k++)
			{
				if (Buffer[k] != Pattern (Files[i].nSeed, k))
				{
					printf ("FAIL: content mismatch in %s at %u\n",
						Files[i].Name, k);
					nErrors++;
					break;
				}
			}
		}
	}

	FileSystem.Synchronize ();
	FileSystem.UnMount ();

	if (nErrors != 0)
	{
		printf ("%s: %u error(s)\n", bWrite ? "write" : "read", nErrors);
		return 1;
	}

	printf ("%s PASS: %u files\n", bWrite ? "write" : "read", nFiles);

	return 0;
}
