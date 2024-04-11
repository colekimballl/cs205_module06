#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#include <QFile>
#include <QFileInfo>
#include <unistd.h>

#include "VCDParser.h"

int main(int argc, char *argv[])
{
#ifdef TEST_MODE
    QString in_file  = "";
    QString out_file = "/media/arails/arails/sim_data/Plugins/SPICEplugin/rsrc/out.h5";
#else
    if (argc < 3)
    {
        std::cout << ".===================================== \n"
                  << "| Analograils Copyright 2005-2011\n"
                  << "| Failure to receive input stream.  \n"
                  << ".====================================="
                  << std::endl;
        exit(0);
    }

    /* argv[1] the input file path
     argv[2] the output file path*/
    QString in_file (argv[1]);
    QString out_file(argv[2]);

    int cnt = 0;
    while (!QFile::exists(in_file))
    {
        sleep(1);

        if ( ++cnt == 30) // 5 seconds
        {
            std::cout << ".=====================================\n"
                      << "| Analograils Copyright 2005-2011 \n"
                      << "| Time-out error  \n"
                      << ".====================================="
                      << std::endl;
            exit(0);
        }
    }
#endif

    /* acquire the stream */
    QFile * in_stream = new QFile(in_file);
    in_stream->open(QIODevice::ReadOnly);

    /* give it to an msim parser */
    VCDParser p(in_stream);

    p.execute(out_file);

    exit(0);
}
