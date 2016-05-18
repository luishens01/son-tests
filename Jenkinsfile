#!groovy
node('node') {

    def err = null
    currentBuild.result = "SUCCESS"

    try {

       stage 'Test'

            env.NODE_ENV = "test"

            print "Environment will be : ${env.NODE_ENV}"

            sh 'echo hola'

       stage 'Build Docker'

            sh 'echo building the container'

       stage 'Deploy'

            echo 'Push to Repo'

       stage 'Cleanup'

            echo 'prune and cleanup'

            mail body: 'project build successful',
                        from: 'sonata-nfv@gmail.com',
                        replyTo: 'sonata-nfv@gmail.com',
                        subject: 'project build successful',
                        to: 'felipe.vicens@atos.net'
        }


    catch (caughtError) {

        err = caughtError
        currentBuild.result = "FAILURE"

            mail body: "project build error: ${err}" ,
            from: 'sonata-nfv@gmail.com',
            replyTo: 'sonata-nfv@gmail.com',
            subject: 'project build successful',
            to: 'felipe.vicens@atos.net'
        }

    finally {


        /* Must re-throw exception to propagate error */
        if (err) {
            throw err
        }

    }

}
