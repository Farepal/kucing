const { OAuth2Client, drive } = require('../config/GoogleDrive.js')
const path = require('path')

exports.DeleteFileInDrive = async (fileId) => {
    if (fileId !== undefined || fileId !== null || fileId !== '') {
        await drive.files.delete({
            fileId: fileId 
        })
    }
}

exports.SaveOneFileToDrive = async (bufferStream, fileObject, fileNameInDrive, folderId) => {
    const fileExtension = path.extname(fileObject.originalname);

    const fileMetadata = {
        name: fileNameInDrive + fileExtension,
        parents: [folderId]
    }

    const media = {
        mimeType: fileObject.mimetype,
        body: bufferStream
    }

    const res = await drive.files.create({
        resource: fileMetadata,
        media: media,
        fields: 'id'
    })

    const fileId = res.data.id;
    return fileId;
}
