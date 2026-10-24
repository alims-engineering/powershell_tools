# Template

| Field             | Description |
| :---------------- | :---------- |
| **Namespace**     |             |
| **Header**        |             |
| **Parameters**    |             |
| **Description**   |             |
| **Precondition**  |             |
| **Postcondition** |             |
| **Exceptions**	|			  |
| **Returns**       |             |

------------------------------------------------------------------------
# compression

## functions

### Compress-FilesToRar

| Field | Description |
| :--- | :--- |
| **Header** | `Compress-FilesToRar -Path <String>` |
| **Parameters** | `-Path` — Specifies the path of the directory whose files will be compressed. This parameter is mandatory. |
| **Description** | Compresses each file directly inside the specified directory into a separate `.rar` archive using WinRAR's `Rar.exe`. Subdirectories and their contents are excluded. Each archive is named after the source file's base name. The function uses the `-ep` option to exclude source paths from the archive, ensuring that each archive contains the file itself without its absolute directory path. |
| **Precondition** | 1. The target directory specified by `-Path` must exist.<br>2. `Rar.exe` must be available at a path derived from the `ProgramFiles` or `ProgramFiles(x86)` environment variable, under `WinRAR\Rar.exe`.<br>3. The current user must have permission to read the source files and write archive files to the target directory. |
| **Postcondition** | Each eligible source file is compressed into an individual `.rar` archive in the target directory. Each archive contains the source file without its absolute source path. Subdirectory contents are not processed. The function reports the success or failure of each compression operation. Existing archives with matching names may be updated by WinRAR. |
| **Exceptions** | 1. The target directory does not exist: reports an error and terminates the function.<br>2. `Rar.exe` cannot be found: reports an error and the candidate paths, then terminates the function.<br>3. Compression fails: reports the archive name and the RAR exit code.<br>4. File access or archive creation errors may cause compression to fail. |
| **Returns** | No explicitly defined return value. Writes status messages to the console. |

