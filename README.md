# simple-intranet-site

This was created to replace an old intranet site at a workplace. Simple a nested list of links. It was outdated to the point where in order for it to work it had to be ran in IE mode in Edge which was causing problems. Due to many of the links requiring local resources, we could not fully host in Sharepoint yet. 

This has been anonymized but can be easily modified for use.

Requirements: 

- Keep the same nested list format as we have currently 
- Make nested links appear when cursor is hovering over said link

Uses: 

- nginx
- Hugo 
- ananke template 

## Structure 

This site is simple a nested list of Links. The structure is as follows. Modify to your needs.

```bash
.
├── Phone List
├── Location/
│   ├── Top/
│       ├── Efficiency Programs/
│       └── Requested Change List/
│   └── ThingstoClick/
├── Another File
├── Subject/
│   ├── MoreThings
│   └── MoreThings2
├── So Many Things

```

## Testing 

Why not overthink this and test with an nginx container? And make it a multi-stage ?

To run in container: 

```docker build -t hugo-intranet .```
```docker run -d -p 8080:80 hugo-intranet```

access via http://localhost:8080/

### Why Multi-Stage? 

The idea of the multistage is for the first stage/ image to do all the building, then copy only the result to serve it in a clean, minimal nginx image. 

For this it is completely overkill (so is containerizing in the first place) but it is good practice / learning opportunity. 