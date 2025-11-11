import { Attachment } from "@models/attachment.model";
import { SignatureBookContentHeader, SignatureBookContentHeaderInterface } from "@models/signature-book.model";

/**
 * Helper function to map attachment data
 * @param data
 * @returns Attachment
 */
export function mapAttachment(data: any): Attachment {
    return new Attachment({
        resId: data.resId,
        resIdMaster: data.resIdMaster ?? data.resId,
        signedResId: data.signedResId,
        chrono: data.chrono,
        title: data.title,
        type: data.type,
        typeLabel: data.typeLabel,
        canConvert: data.isConverted,
        canDelete: data.canDelete,
        canUpdate: data.canModify,
        hasDigitalSignature: data.hasDigitalSignature,
        stamps: [],
        isAttachment: data.resIdMaster !== null,
        externalDocumentId: data.externalDocumentId ?? null,
        fileInformation: data.creationDate ? mapFileInfo({ creationDate: data.creationDate, user: data.creator, version: data.version, format: data.originalFormat }) : null
    });
}

/**
 * Helper function to map content header data
 * @param data
 * @returns SignatureBookContentHeader
 */
export function mapFileInfo(data: { creationDate: string, user: { id: number, label: string }, version: number, format: string }): SignatureBookContentHeaderInterface {
    return new SignatureBookContentHeader ({
        typistId: data.user.id,
        typistLabel: data.user.label,
        creationDate: data.creationDate,
        format: data.format,
        version: data.version
    });
}
