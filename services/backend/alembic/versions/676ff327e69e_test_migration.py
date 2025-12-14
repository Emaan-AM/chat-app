"""Test migration

Revision ID: 676ff327e69e
Revises: 
Create Date: 2025-10-28 00:41:06.904414

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.engine.reflection import Inspector

# revision identifiers, used by Alembic.
revision: str = '676ff327e69e'
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    bind = op.get_bind()
    inspector = Inspector.from_engine(bind)

    if 'message' not in inspector.get_table_names():
        op.create_table(
            'message',
            sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
            sa.Column('text', sa.Text(), nullable=False),
            sa.Column('date', sa.DateTime(), nullable=False),
            sa.PrimaryKeyConstraint('id')
        )


def downgrade() -> None:
    """Downgrade schema."""
    bind = op.get_bind()
    inspector = Inspector.from_engine(bind)

    if 'message' in inspector.get_table_names():
        op.drop_table('message')
