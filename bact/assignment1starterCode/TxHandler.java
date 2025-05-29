import java.security.PublicKey;
import java.util.ArrayList;
import java.util.HashSet;

public class TxHandler {

    /**
     * Creates a public ledger whose current UTXOPool (collection of unspent transaction outputs) is
     * {@code utxoPool}. This should make a copy of utxoPool by using the UTXOPool(UTXOPool uPool)
     * constructor.
     */
    private UTXOPool utxoPool;

    public TxHandler(UTXOPool utxoPool) {
        // IMPLEMENT THIS
        this.utxoPool = new UTXOPool(utxoPool);
    }

    /**
     * @return true if:
     * (1) all outputs claimed by {@code tx} are in the current UTXO pool, 
     * (2) the signatures on each input of {@code tx} are valid, 
     * (3) no UTXO is claimed multiple times by {@code tx},
     * (4) all of {@code tx}s output values are non-negative, and
     * (5) the sum of {@code tx}s input values is greater than or equal to the sum of its output
     *     values; and false otherwise.
     */
    public boolean isValidTx(Transaction tx) {
        // IMPLEMENT THIS
        ArrayList<Transaction.Input> inputs = tx.getInputs();
        ArrayList<Transaction.Output> outputs = tx.getOutputs();
        HashSet<UTXO> claimedUTXO = new HashSet<UTXO>();
        double inputSum = 0;
        double outputSum = 0;

        for (int i = 0; i < inputs.size(); i++) {
            Transaction.Input input = inputs.get(i);

            if (!isConsumedCoinAvailable(input))
                return false;

            if (!verifySignatureOfConsumedCoin(tx, i, input))
                return false;

            if (isUTXOClaimedMultipleTimes(tx, claimedUTXO, input))
                return false;
            
            UTXO utxo = new UTXO(input.prevTxHash, input.outputIndex);
            Transaction.Output prevCorrespondingOutput = utxoPool.getTxOutput(utxo);
            inputSum += prevCorrespondingOutput.value;
        }

        for (int j = 0; j < outputs.size(); j++) {
            Transaction.Output output = outputs.get(j);
            if (output.value <= 0) {
                return false;
            }
            
            outputSum += output.value;
        }

        return inputSum >= outputSum;
    }

    private boolean isConsumedCoinAvailable(Transaction.Input input) {
        UTXO utxo = new UTXO(input.prevTxHash, input.outputIndex);
        return utxoPool.contains(utxo);
    }

    private boolean verifySignatureOfConsumedCoin(Transaction tx, int index, Transaction.Input input) {
        UTXO utxo = new UTXO(input.prevTxHash, input.outputIndex);
        Transaction.Output prevCorrespondingOutput = utxoPool.getTxOutput(utxo);
        PublicKey publicKey = prevCorrespondingOutput.address;
        return Crypto.verifySignature(publicKey, tx.getRawDataToSign(index), input.signature);
    }

    private boolean isUTXOClaimedMultipleTimes(Transaction tx, HashSet<UTXO> claimedUTXO, Transaction.Input input) {
        UTXO utxo = new UTXO(input.prevTxHash, input.outputIndex);
        boolean wasAdded = claimedUTXO.add(utxo);
        boolean isAlreadyClaimed = !wasAdded;
        return isAlreadyClaimed;
    }

    /**
     * Handles each epoch by receiving an unordered array of proposed transactions, checking each
     * transaction for correctness, returning a mutually valid array of accepted transactions, and
     * updating the current UTXO pool as appropriate.
     */
    public Transaction[] handleTxs(Transaction[] possibleTxs) {
        // IMPLEMENT THIS
        ArrayList<Transaction> acceptedTxs = new ArrayList<Transaction>();
        for (int i = 0; i < possibleTxs.length; i++) {
            Transaction tx = possibleTxs[i];
            if (isValidTx(tx)) {
                acceptedTxs.add(tx);
                removeConsumedCoinsFromPool(tx);
                addCreatedCoinsToPool(tx);
            }
        }

        Transaction[] acceptedTxsArray = new Transaction[acceptedTxs.size()];
        for (int i = 0; i < acceptedTxs.size(); i++) {
            acceptedTxsArray[i] = acceptedTxs.get(i);
        }
        return acceptedTxsArray;
    }

    private void removeConsumedCoinsFromPool(Transaction tx) {
        ArrayList<Transaction.Input> inputs = tx.getInputs();
        for (int i = 0; i < inputs.size(); i++) {
            Transaction.Input input = inputs.get(i);
            UTXO utxo = new UTXO(input.prevTxHash, input.outputIndex);
            utxoPool.removeUTXO(utxo);
        }
    }

    private void addCreatedCoinsToPool(Transaction tx) {
        ArrayList<Transaction.Output> outputs = tx.getOutputs();
        for (int i = 0; i < outputs.size(); i++) {
            Transaction.Output output = outputs.get(i);
            UTXO utxo = new UTXO(tx.getHash(), i);
            utxoPool.addUTXO(utxo, output);
        }
    }
}
