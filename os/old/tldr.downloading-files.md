# Downloading things 

Sometimes the files aren't just given to us so we need to download them, but how do we do that? 

Linux comes with two standard tools `wget` and `curl`. 

## wget

* Purpose: Primarily designed for downloading files.
* Recursive Downloading: Supports recursive downloading, meaning it can download an entire website by following links.
* Resuming Downloads: Can resume downloads if the connection is interrupted.
* Single-Threaded: Downloads files using a single thread.
* Protocols Supported: Mainly HTTP, HTTPS, and FTP.
* Ease of Use: Simple and straightforward, often easier for basic downloading tasks.
* Batch Downloads: Can download multiple files at once using a single command.
* Output: Provides less control over the output format compared to curl.


## curl

* Purpose: A more general-purpose tool for transferring data to and from a server.
* Protocols Supported: Supports a wide range of protocols including HTTP, HTTPS, FTP, FTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS, FILE, IMAP, SMTP, POP3, RTSP, RTMP, and more.
* Flexibility: Highly flexible and customizable, with numerous options and flags for various tasks.
* Multiple Features: Can be used for both downloading and uploading files, and supports a wide range of HTTP methods (GET, POST, PUT, DELETE, etc.).
* Resuming Downloads: Can resume downloads if the connection is interrupted.
* Parallel Downloads: Can download files in parallel using multiple connections.
* Output: Allows more control over the output format, which is useful for scripting and automation.
* Data Manipulation: Capable of more complex data manipulation tasks, such as setting HTTP headers, handling cookies, and form submissions.

## Summary

wget is ideal for straightforward file downloads, especially when dealing with recursive downloading or batch downloads.

curl is more versatile and powerful, suitable for complex tasks involving various protocols and data manipulation.

In general, if you need to download a single file or an entire website, wget is often the simpler choice. If you need to interact with web services, upload files, or handle complex tasks, curl is the better option.

How to download files? 

```bash
wget http://XXX.XXX.XXX.XXX/file.name
curl -o http://XXX.XXX.XXX.XXX/file.name
```