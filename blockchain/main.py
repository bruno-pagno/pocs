from time import time
from typing import List
import hashlib

# Transactions consists of a list of words in this blockchain
class Block:
    def __init__(self, transactions: List[str], previous_hash: str):
        self.timestamp = time()
        self.transactions = transactions
        self.previous_hash = previous_hash
    
class Blockchain:
    @staticmethod
    def hash_block(block: Block):
        block_information_string = '-'.join(block.transactions) + '-' + str(block.timestamp)
        return hashlib.sha256(block_information_string.encode()).hexdigest()
    
    def __init__(self, transactions: List[str]):
        initial_hash = 'initial_hash'
        initial_block = Block(transactions, previous_hash=initial_hash)
        self.len = 1
        self.chain = [initial_block]
    
    def append_block(self, transactions: List[str]) -> Block:
        previous_hash = Blockchain.hash_block(self.chain[-1])
        block = Block(transactions, previous_hash)
        self.chain.append(block)
        self.len += 1
        return block
    
    def print_blocks(self):
        for block in self.chain:
            print('prev-hash:', block.previous_hash, 'transactions:', block.transactions, )

if __name__ == '__main__':
    blockchain = Blockchain(['hello', 'world'])
    blockchain.append_block(['foo', 'bar', 'baz'])
    blockchain.append_block(['john', 'doe'])
    blockchain.print_blocks()